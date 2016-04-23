--魔導契約の扉
--Gate of the Magical Contract
--Script by dest
function c100207020.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100207020.target)
	e1:SetOperation(c100207020.activate)
	c:RegisterEffect(e1)
end
function c100207020.filter(c)
	return (c:GetLevel()==7 or c:GetLevel()==8) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToHand()
end
function c100207020.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND,0,1,e:GetHandler(),TYPE_SPELL)
		and Duel.IsExistingMatchingCard(c100207020.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100207020.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100207020,0))
	local ag=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND,0,1,1,nil,TYPE_SPELL)
	if ag:GetCount()>0 then
		Duel.SendtoHand(ag,1-tp,REASON_EFFECT)
		Duel.ConfirmCards(tp,ag)
		Duel.ShuffleHand(tp)
		Duel.ShuffleHand(1-tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c100207020.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
