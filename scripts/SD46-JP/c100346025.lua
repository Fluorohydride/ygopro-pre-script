--アブソリュート・パワーフォース
--
--Script by Trishula9
function c100346025.initial_effect(c)
	aux.AddCodeList(c,70902743)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c100346025.condition)
	e1:SetTarget(c100346025.target)
	e1:SetOperation(c100346025.activate)
	c:RegisterEffect(e1)
end
function c100346025.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()<PHASE_MAIN2
end
function c100346025.filter(c)
	return c:IsFaceup() and c:IsCode(70902743) and c:GetFlagEffect(100346025)==0
end
function c100346025.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c100346025.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100346025.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c100346025.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c100346025.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:GetFlagEffect(100346025)==0 then
			tc:RegisterFlagEffect(100346025,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetCondition(c100346025.atkcon)
			e1:SetValue(1000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetCode(EFFECT_CANNOT_ACTIVATE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetTargetRange(0,1)
			e2:SetCondition(c100346025.actcon)
			e2:SetValue(1)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2,true)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_PIERCE)
			e3:SetCondition(c100346025.effcon)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
			e4:SetCondition(c100346025.damcon)
			e4:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
			e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e4,true)
		end
	end
end
function c100346025.atkcon(e)
	if bit.band(Duel.GetCurrentPhase(),PHASE_DAMAGE+PHASE_DAMAGE_CAL)==0 then return false end
	local c=e:GetHandler()
	return (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c) and c:GetBattleTarget()~=nil
		and e:GetOwnerPlayer()==e:GetHandlerPlayer()
end
function c100346025.actcon(e)
	local c=e:GetHandler()
	return (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c) and c:GetBattleTarget()~=nil
		and e:GetOwnerPlayer()==e:GetHandlerPlayer()
end
function c100346025.effcon(e)
	return e:GetOwnerPlayer()==e:GetHandlerPlayer()
end
function c100346025.damcon(e)
	return e:GetHandler():GetBattleTarget()~=nil
end