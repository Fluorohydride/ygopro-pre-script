--トリックスター・ベラマドンナ
--Trickstar Bella Madonna
--Script by nekrozar
function c101004038.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xfb),2)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c101004038.imcon)
	e1:SetValue(c101004038.immval)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101004038,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101004038)
	e2:SetCondition(c101004038.damcon)
	e2:SetTarget(c101004038.damtg)
	e2:SetOperation(c101004038.damop)
	c:RegisterEffect(e2)
end
function c101004038.imcon(e)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK) and c:GetLinkedGroupCount()==0
end
function c101004038.immval(e,te)
	return te:GetOwner()~=e:GetHandler() and te:IsActivated()
end
function c101004038.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLinkedGroupCount()==0
end
function c101004038.damfilter(c)
	return c:IsSetCard(0xfb) and c:IsType(TYPE_MONSTER)
end
function c101004038.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101004038.damfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c101004038.damfilter,tp,LOCATION_GRAVE,0,nil)
	local dam=g:GetClassCount(Card.GetCode)*200
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c101004038.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c101004038.damfilter,tp,LOCATION_GRAVE,0,nil)
	local dam=g:GetClassCount(Card.GetCode)*200
	Duel.Damage(p,dam,REASON_EFFECT)
end
