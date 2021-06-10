--魔鍵交鬼一トランスフルミネ
--scripted by XyLeN
function c101106044.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x165),aux.NonTuner(aux.FilterBoolFunction(Card.IsType,TYPE_NORMAL)),1)
	c:EnableReviveLimit()
	--mass register
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101106044.matcon)
	e1:SetOperation(c101106044.matop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetLabelObject(e1)
	e2:SetValue(c101106044.valcheck)
	c:RegisterEffect(e2)
	--attack twice
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101106044,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,101106044)
	e4:SetCondition(c101106044.setcon)
	e4:SetTarget(c101106044.settg)
	e4:SetOperation(c101106044.setop)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(101106044,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,101106044+100)
	e5:SetCondition(c101106044.descon)
	e5:SetTarget(c101106044.destg)
	e5:SetOperation(c101106044.desop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
end
function c101106044.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(101106044)~=0
end
function c101106044.setfilter(c)
	return c:IsSetCard(0x165) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c101106044.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101106044.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c101106044.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c101106044.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end
function c101106044.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()==1
end
function c101106044.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(101106044,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(101106044,2))
end
function c101106044.attfilter(c,rc)
	return c:GetAttribute()>0
end
function c101106044.valcheck(e,c)
	local mg=c:GetMaterial()
	local fg=mg:Filter(c71159974.attfilter,nil,c)
	if fg:GetClassCount(Card.GetAttribute)==2 then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c101106044.cfilter(c,tp,attr)
	return c:IsAttribute(attr) and c:IsSummonPlayer(1-tp)
end
function c101106044.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_GRAVE,0,nil)
	local tc=g:GetFirst() 
	local attr=0
	while tc do
		attr=attr|tc:GetAttribute() 
		tc=g:GetNext() 
	end
	return eg:IsExists(c101106044.cfilter,1,nil,tp,attr)
end
function c101106044.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c101106044.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(eg,REASON_EFFECT)
end
