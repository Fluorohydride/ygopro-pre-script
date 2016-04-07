--EMドラネコ
--Performapal Gongcat
--Scripted by Eerie Code
function c100909002.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--Negate damage (direct)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100909002,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1)
	e1:SetCondition(c100909002.dmcon1)
	e1:SetOperation(c100909002.dmop)
	c:RegisterEffect(e1)
	--Negate damage (monster)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c100909002.dmcon2)
	c:RegisterEffect(e2)
end
function c100909002.dmcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c100909002.dmop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetOperation(c100909002.damop)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c100909002.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,0)
end
function c100909002.dmcon2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d and a:GetControler()~=d:GetControler()
end
