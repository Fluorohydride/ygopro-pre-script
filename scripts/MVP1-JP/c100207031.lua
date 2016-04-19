--光の護封霊剣
--Soul Swords of Revealing Light
--Script by nekrozar
function c100207031.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100207031.target1)
	e1:SetOperation(c100207031.operation)
	c:RegisterEffect(e1)
	--disable attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100207031,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c100207031.condition)
	e2:SetCost(c100207031.cost)
	e2:SetTarget(c100207031.target2)
	e2:SetOperation(c100207031.operation)
	c:RegisterEffect(e2)
end
function c100207031.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c100207031.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c100207031.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) and tp~=Duel.GetTurnPlayer()
		and Duel.CheckLPCost(tp,1000) and Duel.SelectYesNo(tp,94) then
		Duel.PayLPCost(tp,1000)
		e:GetHandler():RegisterFlagEffect(100207031,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		e:GetHandler():RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,65)
	end
end
function c100207031.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(100207031)==0 end
	e:GetHandler():RegisterFlagEffect(100207031,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c100207031.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(100207031)==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.NegateAttack()
end
