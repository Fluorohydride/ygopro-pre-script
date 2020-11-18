--异热同心构筑
function c101104207.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101104207,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101104207+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101104207.target)
	e1:SetOperation(c101104207.activate)
	c:RegisterEffect(e1)	 
end
function c101104207.filter(c)
	return (((c:IsSetCard(0x107e) or c:IsSetCard(0x207e)) and c:IsType(TYPE_MONSTER)) or (c:IsSetCard(0x7e) and c:IsType(TYPE_SPELL+TYPE_TRAP)) or ((c:IsSetCard(0x95) or c:IsSetCard(0x25b)) and c:IsType(TYPE_SPELL))) and c:IsAbleToHand()
end
function c101104207.tdfilter(c)
	return not c:IsPublic() and c:IsAbleToDeck()
end
function c101104207.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101104207.filter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c101104207.tdfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101104207.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c101104207.tdfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c101104207.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()~=0 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
		Duel.BreakEffect()
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end