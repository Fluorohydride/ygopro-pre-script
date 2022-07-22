--Upside Down
--Scripted by: XGlitchy30

function c101110080.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101110080,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101110080.target)
	e1:SetOperation(c101110080.activate)
	e1:SetHintTiming(0,TIMING_MAIN_END+TIMING_END_PHASE)
	c:RegisterEffect(e1)
end
function c101110080.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<2 then return false end
		local bottom=Duel.GetFieldGroup(tp,LOCATION_DECK,0):GetMinGroup(Card.GetSequence)
		return #bottom==1 and bottom:GetFirst():IsAbleToHand()
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101110080.activate(e,tp,eg,ep,ev,re,r,rp)
	local bottom=Duel.GetFieldGroup(tp,LOCATION_DECK,0):GetMinGroup(Card.GetSequence)
	if #bottom~=1 then return end
	local tc=bottom:GetFirst()
	if tc:IsAbleToHand() and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		Duel.ShuffleDeck(tp)
		if tc:IsLocation(LOCATION_HAND) then
			local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
			if #g<=1 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local sc=g:Select(tp,1,1,nil):GetFirst()
			if sc then
				Duel.BreakEffect()
				Duel.MoveSequence(sc,1)
			end
		end
	else
		Duel.SendtoGrave(tc,REASON_RULE)
	end
end