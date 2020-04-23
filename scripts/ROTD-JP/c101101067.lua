--賽挑戦
--
--Script by JoyJ
function c101101067.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,101101067+EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101101067.target)
	e1:SetOperation(c101101067.activate)
	c:RegisterEffect(e1)
end
c101101067.toss_dice=true
function c101101067.filter(c)
	return c.toss_dice and c:IsAbleToHand()
end
function c101101067.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end
function c101101067.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dice1=Duel.TossDice(tp,1)
	if (dice1==1 or dice1==6) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,c101101067.filter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
		return
	elseif c:IsRelateToEffect(e) then
		local dice2=Duel.TossDice(tp,1)
		if (dice2==1 or dice2==6) then
			c:CancelToGrave()
			Duel.SendtoHand(c,nil,REASON_EFFECT)
		elseif dice2>=2 and dice2<=5 then
			c:CancelToGrave()
			Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
		end
	end
end
