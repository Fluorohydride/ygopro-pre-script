--フォトン・リタデイション
--
--Script by Trishula9
function c101111071.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101111071.target)
	e1:SetOperation(c101111071.activate)
	c:RegisterEffect(e1)
	--end turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c101111071.etcon)
	e2:SetOperation(c101111071.etop)
	c:RegisterEffect(e2)
end
function c101111071.filter(c,tp)
	return c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x55,0x7b)
		and (c:IsAbleToHand() or (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not c:IsForbidden() and c:CheckUniqueOnField(tp)))
end
function c101111071.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101111071.filter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c101111071.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,c101111071.filter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		if tc:IsAbleToHand() and (Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsForbidden() or not tc:CheckUniqueOnField(tp) or Duel.SelectOption(tp,1190,aux.Stringid(101111071,1))==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
function c101111071.cfilter(c)
	return (c:IsCode(93717133) or (c:IsType(TYPE_XYZ) and c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,93717133))) and c:IsFaceup()
end
function c101111071.etcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and c:IsPreviousControler(tp) and c:IsReason(REASON_EFFECT)
		and c:GetReasonPlayer()==1-tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
		and Duel.IsExistingMatchingCard(c101111071.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101111071.etop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SkipPhase(1-tp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end