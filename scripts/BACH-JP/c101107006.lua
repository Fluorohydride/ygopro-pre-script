--氷水帝コスモクロア
--
--Script by Trishula9
function c101107006.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101107006+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101107006.spcon)
	c:RegisterEffect(e1)
	--cannot activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_TRIGGER)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c101107006.actcon)
	e2:SetTarget(c101107006.actlimit)
	c:RegisterEffect(e2)
	--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(c101107006.atkcon)
	e3:SetTarget(c101107006.atktg)
	e3:SetValue(-1000)
	c:RegisterEffect(e3)
end
function c101107006.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function c101107006.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(101107052)
end
function c101107006.actlimit(e,c)
	return not c:IsStatus(STATUS_SUMMON_TURN+STATUS_FLIP_SUMMON_TURN+STATUS_SPSUMMON_TURN)
end
function c101107006.atkcon(e)
	local tp=e:GetHandlerPlayer()
	local a,d=Duel.GetBattleMonster(tp)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and a and d and a:IsSetCard(0x16c)
end
function c101107006.atktg(e,c)
	local tp=e:GetHandlerPlayer()
	local a,d=Duel.GetBattleMonster(tp)
	return c==d
end
