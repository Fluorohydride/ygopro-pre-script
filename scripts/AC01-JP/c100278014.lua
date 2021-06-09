--氷騎士
--scripted by XyLeN
function c100278014.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c100278014.val)
	c:RegisterEffect(e1)
	--extra normal summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100278014,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c100278014.sumcon)
	e2:SetTarget(c100278014.sumtg)
	e2:SetOperation(c100278014.sumop)
	c:RegisterEffect(e2)
end
function c100278014.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_AQUA)
end
function c100278014.val(e,c)
	return Duel.GetMatchingGroupCount(c100278014.cfilter,c:GetControler(),LOCATION_MZONE,0,nil)*400
end
function c100278014.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,100278014)==0
end
function c100278014.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSummon(tp) and Duel.IsPlayerCanAdditionalSummon(tp) end
end
function c100278014.sumop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(100278014,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(c100278014.extrasumtg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,100278014,RESET_PHASE+PHASE_END,0,1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c100278014.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e3,tp)
end
function c100278014.extrasumtg(e,c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end
function c100278014.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
