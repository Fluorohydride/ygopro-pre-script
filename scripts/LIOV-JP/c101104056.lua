--アメイジングタイムチケット
--Amazing Time Ticket
--Scripted by Kohana Sonogami
function c101104056.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101104056+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c101104056.cost)
	e1:SetTarget(c101104056.target)
	e1:SetOperation(c101104056.activate)
	c:RegisterEffect(e1)
end
function c101104056.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c101104056.thfilter(c)
	return c:IsSetCard(0x25e) and c:IsAbleToHand()
end
function c101104056.setfilter(c)
	return c:IsSetCard(0x25f) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c101104056.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetTurnPlayer()==tp then
		if chk==0 then return Duel.IsExistingMatchingCard(c101104056.thfilter,tp,LOCATION_DECK,0,1,nil) end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		if chk==0 then return Duel.IsExistingMatchingCard(c101104056.setfilter,tp,LOCATION_DECK,0,1,nil) end
	end
end
function c101104056.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c101104056.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c101104056.setfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc and Duel.SSet(tp,tc)~=0 then
			if tc:IsType(TYPE_TRAP) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
		end
	end
end
