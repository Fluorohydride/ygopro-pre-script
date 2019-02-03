--身代わりの闇
--
--Script by JoyJ
function c100236113.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c100236113.Condition)
	e1:SetTarget(c100236113.Target)
	e1:SetOperation(c100236113.Operation)
	c:RegisterEffect(e1)
end
function c100236113.TargetFilter(c)
	return c:IsLevelBelow(3) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToGrave()
end
function c100236113.Operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and Duel.IsExistingMatchingCard(c100236113.TargetFilter,tp,LOCATION_DECK,0,1,nil) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		Duel.SendtoGrave(Duel.SelectMatchingCard(tp,c100236113.TargetFilter,tp,LOCATION_DECK,0,1,1,nil),REASON_EFFECT)
	end
end
function c100236113.Target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100236113.TargetFilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c100236113.Condition(e,tp,eg,ep,ev,re,r,rp)
	if not (tp~=ep and Duel.IsChainDisablable(ev)) then return false end
	local haveThisCategory,targetCards=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	targetCards = targetCards:Filter(Card.IsOnField,nil)
	
	return haveThisCategory and targetCards:GetCount() > 0
end
