--Exchanging Souls
--scripted by TOP & Lyris
function c100272003.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100272003,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,100272003+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100272003.sumcon)
	e1:SetTarget(c100272003.sumtg)
	e1:SetOperation(c100272003.sumop)
	c:RegisterEffect(e1)
end
function c100272003.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c100272003.sumfilter(c,ec)
	if not c:IsRace(RACE_DIVINE) then return false end
	local e1=Effect.CreateEffect(ec)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	:RegisterEffect(e1)
	local res=c:IsSummonable(true,nil,1)
	e1:Reset()
	return res
end
function c100272003.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100272003.sumfilter,tp,LOCATION_HAND,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c100272003.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,c100272003.sumfilter,tp,LOCATION_HAND,0,1,1,nil,c):GetFirst()
	if tc then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
		e1:SetRange(LOCATION_HAND)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetValue(POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		Duel.Summon(tp,tc,true,nil,1)
		--can't activate effects
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAINING)
		e2:SetCondition(c100272003.regcon)
		e2:SetOperation(c100272003.regop)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_CANNOT_ACTIVATE)
		e3:SetTargetRange(1,0)
		e3:SetCondition(c100272003.actcon)
		e3:SetValue(c100272003.aclimit)
		e3:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e3,tp)
	end
end
function c100272003.regcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and not re:GetHandler():IsRace(RACE_DIVINE)
end
function c100272003.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,100272003,RESET_PHASE+PHASE_END,2,0,1)
end
function c100272003.actcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,100272003)>0
end
function c100272003.aclimit(e,re,tp)
	return not re:GetHandler():IsRace(RACE_DIVINE)
end
