--Libromancer Displaced
local s,id,o=GetID()
function s.initial_effect(c)
	--Target 1 "Libromancer" monster you control and 1 monster your opponent controls; return your monster to the hand, and if you do, take control of that opponent's monster. If your "Libromancer" monster you targeted was not a Ritual Monster, the monster you took control of returns to the hand during the End Phase. You can only activate 1 "Libromancer Displaced" per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_CONTROL+CATEGORY_TOHAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(aux.AND(Card.IsFaceup,Card.IsSetCard),tp,LOCATION_MZONE,0,1,nil,0x17c)
		and Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,Duel.SelectTarget(tp,aux.AND(Card.IsFaceup,Card.IsSetCard),tp,LOCATION_MZONE,0,1,1,nil,0x17c),1,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil),1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local th,hc=Duel.GetOperationInfo(0,CATEGORY_TOHAND)
	local chk=hc:IsType(TYPE_RITUAL)
	if hc:IsRelateToEffect(e) and Duel.SendtoHand(hc,nil,REASON_EFFECT)>0 and hc:IsLocation(LOCATION_HAND) then
		local cn,tc=Duel.GetOperationInfo(0,CATEGORY_CONTROL)
		if tc:IsRelateToEffect(e) and Duel.GetControl(tc,tp) and not chk then
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCondition(function() return tc:GetFlagEffect(id)>0 end)
			e1:SetOperation(function() Duel.SendtoHand(tc,nil,REASON_EFFECT) end)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
