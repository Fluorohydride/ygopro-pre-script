--天地返
function c101110080.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101110080.tg)
	e1:SetOperation(c101110080.op)
	c:RegisterEffect(e1)
end
function c101110080.tg(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1
end
function c101110080.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if g:GetCount()==0 then return end
	local tc=g:GetMinGroup(Card.GetSequence):GetFirst()
	Duel.DisableShuffleCheck()
	if Duel.SendtoHand(tc,tp,REASON_EFFECT) then
		Duel.ConfirmCards(1-tp,tc)
		Duel.ShuffleHand(tp)
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end 
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101110080,1))
		local seg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_DECK,0,1,1,nil)
		local sec=seg:GetFirst()
		if sec then
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(sec,SEQ_DECKBOTTOM)
		end
	end
end