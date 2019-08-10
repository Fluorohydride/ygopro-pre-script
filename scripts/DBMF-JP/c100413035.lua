--王の試練

--Scripted by nekrozar
function c100413035.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100413035+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100413035.target)
	e1:SetOperation(c100413035.activate)
	c:RegisterEffect(e1)
end
function c100413035.filter1(c)
	return c:IsSetCard(0x134) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and not c:IsPublic()
end
function c100413035.filter2(c)
	return c:IsSetCard(0x134) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(100413035) and c:IsAbleToHand()
end
function c100413035.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100413035.filter1,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(c100413035.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100413035.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,c100413035.filter1,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g1)
	if g1:GetCount()==0 then return end
	local g2=Duel.GetMatchingGroup(c100413035.filter2,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g2:SelectSubGroup(tp,aux.dncheck,false,1,2)
	if sg and Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.SendtoDeck(g1,nil,1,REASON_EFFECT)
	end
end
