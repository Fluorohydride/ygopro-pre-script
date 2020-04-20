--从骰挑战
function c101101067.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,101101067)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101101067.target)
	e1:SetOperation(c101101067.activate)
	c:RegisterEffect(e1)
	--remain field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e2)
end
c101101067.toss_dice=true
--NEED ALL DICE-TOSSING EFFECT CARD TO BE CHANGED LIKE THIS
function c101101067.filter(c)
	return c.toss_dice and c:IsAbleToHand()
end
function c101101067.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101101067.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101101067.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dice1=Duel.TossDice(tp,1)
	if (dice1==1 or dice1==6) then
		local tc=Duel.SelectMatchingCard(tp,c101101067.filter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
		return
	end
	c:CancelToGrave()
	local dice2=Duel.TossDice(tp,1)
	if (dice2==1 or dice2==6) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		return
	end
	Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
end
