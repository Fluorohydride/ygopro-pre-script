--ハンディ・ギャロップ
--
--Script by mercury233
function c101008026.initial_effect(c)
	--cannot direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--atk update
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c101008026.atkval)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetCondition(c101008026.damcon)
	e3:SetOperation(c101008026.damop)
	c:RegisterEffect(e3)
end
function c101008026.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetLP(tp)>Duel.GetLP(1-tp)
end
function c101008026.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(1-ep,ev,false)
	Duel.ChangeBattleDamage(ep,0,false)
end
function c101008026.atkval(e,c)
	return math.abs(Duel.GetLP(0)-Duel.GetLP(1))
end
