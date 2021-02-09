--スネーク・レイン

--scripted by Xylen5967
function c100416042.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c100416042.cost)
	e1:SetTarget(c100416042.target)
	e1:SetOperation(c100416042.activate)
	c:RegisterEffect(e1)
end
function c100416042.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c100416042.filter(c)
	return c:IsRace(RACE_REPTILE) and c:IsAbleToDeck() 
end
function c100416042.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100416042.filter,tp,LOCATION_GRAVE,0,4,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,4,tp,LOCATION_GRAVE)
end
function c100416042.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100416042.filter,tp,LOCATION_GRAVE,0,nil)
	if #g<4 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local dg=g:Select(tp,4,4,nil)
	Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
end
