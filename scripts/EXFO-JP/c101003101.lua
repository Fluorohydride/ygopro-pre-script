--見切りの極意
--Critical Timing
--Scripted by Eerie Code
function c101003101.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c101003101.condition)
	e1:SetTarget(c101003101.target)
	e1:SetOperation(c101003101.activate)
	c:RegisterEffect(e1)
end
function c101003101.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
		and Duel.IsExistingMatchingCard(Card.IsCode,tp,0,LOCATION_GRAVE,1,nil,re:GetHandler():GetCode())
		and Duel.IsChainNegatable(ev)
end
function c101003101.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c101003101.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
