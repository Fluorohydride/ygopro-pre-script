--闇味鍋パーティー

--Scripted by nekrozar
function c100261004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--attack select
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100261004,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,100261004)
	e2:SetCondition(c100261004.atkcon1)
	e2:SetTarget(c100261004.atktg1)
	e2:SetOperation(c100261004.atkop1)
	c:RegisterEffect(e2)
end
function c100261004.atkcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c100261004.atktg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c100261004.atkop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:GetFlagEffect(100261004)==0 then
			tc:RegisterFlagEffect(100261004,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_ATTACK_ANNOUNCE)
			e3:SetCondition(c100261004.atkcon2)
			e3:SetOperation(c100261004.atkop2)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
end
function c100261004.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	local ag=eg:GetFirst():GetAttackableTarget()
	local at=e:GetHandler():GetBattleTarget()
	return at~=nil and ag:IsExists(aux.TRUE,1,at)
end
function c100261004.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local ag=eg:GetFirst():GetAttackableTarget()
	local at=e:GetHandler():GetBattleTarget()
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATTACKTARGET)
	local g=ag:Select(1-tp,1,1,at)
	local tc=g:GetFirst()
	if tc then
		Duel.ChangeAttackTarget(tc)
	end
end
