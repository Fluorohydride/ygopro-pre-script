--Ai-Q
function c101012073.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END+TIMING_END_PHASE)
	e1:SetCondition(c101012073.condition)
	c:RegisterEffect(e1)
	--maintain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(c101012073.descon)
	e2:SetOperation(c101012073.desop)
	c:RegisterEffect(e2)
	--link summon count limit
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c101012073.regcon1)
	e3:SetOperation(c101012073.regop1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCondition(c101012073.regcon2)
	e4:SetOperation(c101012073.regop2)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(101012073)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(1,1)
	c:RegisterEffect(e5)
end
function c101012073.regfilter(c,tp)
	return c:IsSummonType(SUMMON_TYPE_LINK) and c:GetSummonPlayer()==tp
end
function c101012073.regcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101012073.regfilter,1,nil,tp)
end
function c101012073.regop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetTarget(c101012073.splimit)
	c:RegisterEffect(e1)
end
function c101012073.regcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101012073.regfilter,1,nil,1-tp)
end
function c101012073.regop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetTarget(c101012073.splimit)
	c:RegisterEffect(e1)
end
function c101012073.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c101012073.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x135)
end
function c101012073.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101012073.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c101012073.desfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c101012073.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c101012073.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	if Duel.CheckReleaseGroup(tp,c101012073.desfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(101012073,0)) then
		local g=Duel.SelectReleaseGroup(tp,c101012073.desfilter,1,1,nil)
		Duel.Release(g,REASON_COST)
	else Duel.Destroy(c,REASON_COST) end
end
