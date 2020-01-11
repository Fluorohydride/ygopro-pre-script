--アークネメシス・エスカトス

--Scripted by mallu11
function c101012009.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101012009.sprcon)
	e1:SetTarget(c101012009.sprtg)
	e1:SetOperation(c101012009.sprop)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101012009,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101012009)
	e3:SetTarget(c101012009.destg)
	e3:SetOperation(c101012009.desop)
	c:RegisterEffect(e3)
end
function c101012009.sprfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToRemoveAsCost()
end
function c101012009.fselect(g,tp)
	return Duel.GetMZoneCount(tp,g)>0 and g:GetClassCount(Card.GetRace)==#g
end
function c101012009.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(c101012009.sprfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	return rg:CheckSubGroup(c101012009.fselect,3,3,tp)
end
function c101012009.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetMatchingGroup(c101012009.sprfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=rg:SelectSubGroup(tp,c101012009.fselect,true,3,3,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c101012009.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	g:DeleteGroup()
end
function c101012009.desfilter(c,race)
	return c:IsFaceup() and c:IsRace(race)
end
function c101012009.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	local race=0
	while tc do
		race=race|tc:GetRace()
		tc=g:GetNext()
	end
	local rc=Duel.AnnounceRace(tp,1,race)
	e:SetLabel(rc)
	local dg=Duel.GetMatchingGroup(c101012009.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,rc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c101012009.desop(e,tp,eg,ep,ev,re,r,rp)
	local race=e:GetLabel()
	local dg=Duel.GetMatchingGroup(c101012009.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,race)
	if dg:GetCount()>0 then
		Duel.Destroy(dg,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,1)
	e1:SetLabel(race)
	e1:SetTarget(c101012009.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function c101012009.splimit(e,c)
	return c:IsRace(e:GetLabel())
end
