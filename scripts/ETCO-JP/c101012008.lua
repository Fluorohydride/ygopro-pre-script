--アークネメシス・プロートス

--Scripted by mallu11
function c101012008.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101012008.sprcon)
	e1:SetTarget(c101012008.sprtg)
	e1:SetOperation(c101012008.sprop)
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
	e3:SetDescription(aux.Stringid(101012008,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101012008)
	e3:SetTarget(c101012008.destg)
	e3:SetOperation(c101012008.desop)
	c:RegisterEffect(e3)
end
function c101012008.sprfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToRemoveAsCost()
end
function c101012008.fselect(g,tp)
	return Duel.GetMZoneCount(tp,g)>0 and g:GetClassCount(Card.GetAttribute)==#g
end
function c101012008.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(c101012008.sprfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	return rg:CheckSubGroup(c101012008.fselect,3,3,tp)
end
function c101012008.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetMatchingGroup(c101012008.sprfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=rg:SelectSubGroup(tp,c101012008.fselect,true,3,3,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c101012008.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	g:DeleteGroup()
end
function c101012008.desfilter(c,attr)
	return c:IsFaceup() and c:IsAttribute(attr)
end
function c101012008.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	local attr=0
	while tc do
		attr=attr|tc:GetAttribute()
		tc=g:GetNext()
	end
	local at=Duel.AnnounceAttribute(tp,1,attr)
	e:SetLabel(at)
	local dg=Duel.GetMatchingGroup(c101012008.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,at)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c101012008.desop(e,tp,eg,ep,ev,re,r,rp)
	local attr=e:GetLabel()
	local dg=Duel.GetMatchingGroup(c101012008.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,attr)
	if dg:GetCount()>0 then
		Duel.Destroy(dg,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,1)
	e1:SetLabel(attr)
	e1:SetTarget(c101012008.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function c101012008.splimit(e,c)
	return c:IsAttribute(e:GetLabel())
end
