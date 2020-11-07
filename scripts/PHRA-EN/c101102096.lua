--Myutant Expansion
--
--Script by JoyJ
function c101102096.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101102096+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetOperation(c101102096.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c101102096.reptg)
	e2:SetValue(c101102096.repval)
	e2:SetOperation(c101102096.repop)
	c:RegisterEffect(e2)
end
function c101102096.filter(c,e,tp,check)
	return c:IsSetCard(0x258) and c:IsLevelBelow(4)
		and ((check and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) or c:IsAbleToHand())
end
function c101102096.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101102096.filter,tp,LOCATION_DECK,0,nil,Duel.GetMZoneCount(tp)>0)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(101102096,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		local opt=0
		if not tc:IsAbleToHand() then
			opt=0
		elseif not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			opt=1
		else
			opt=Duel.SelectOption(tp,1190,1152)
		end
		if opt==0 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c101102096.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x258) and c:IsLocation(LOCATION_MZONE) and c:IsLevelAbove(8)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c101102096.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED)
		and eg:IsExists(c101102096.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c101102096.repval(e,c)
	return c101102096.repfilter(c,e:GetHandlerPlayer())
end
function c101102096.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
