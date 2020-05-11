--機皇統制

--Scripted by mallu11
function c100424021.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100424021,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,100424021+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(aux.dscon)
	e1:SetTarget(c100424021.target)
	e1:SetOperation(c100424021.activate)
	c:RegisterEffect(e1)
	--Destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c100424021.reptg)
	e2:SetValue(c100424021.repval)
	c:RegisterEffect(e2)
end
function c100424021.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x13)
end
function c100424021.filter(c,atk)
	return c100424021.atkfilter(c) and not c:IsAttack(atk)
end
function c100424021.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c100424021.atkfilter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()<=0 then return false end
	local atk=g:GetSum(Card.GetBaseAttack)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100424021.filter(chkc,atk) end
	if chk==0 then return Duel.IsExistingTarget(c100424021.filter,tp,LOCATION_MZONE,0,1,nil,atk) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c100424021.filter,tp,LOCATION_MZONE,0,1,1,nil,atk)
end
function c100424021.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:IsFaceup() then
			local atk=0
			local g=Duel.GetMatchingGroup(c100424021.atkfilter,tp,LOCATION_MZONE,0,nil)
			if g:GetCount()>0 then atk=g:GetSum(Card.GetBaseAttack) end
			--atk
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
		--damage 0
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_NO_BATTLE_DAMAGE)
		e2:SetCondition(c100424021.damcon)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetOwnerPlayer(tp)
		tc:RegisterEffect(e2,true)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		e3:SetCondition(c100424021.damcon2)
		e3:SetValue(1)
		tc:RegisterEffect(e3,true)
	end
end
function c100424021.damcon(e)
	return e:GetHandlerPlayer()==e:GetOwnerPlayer()
end
function c100424021.damcon2(e)
	return 1-e:GetHandlerPlayer()==e:GetOwnerPlayer()
end
function c100424021.repfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0x13)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c100424021.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c100424021.repfilter,1,nil,tp) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
		return true
	else return false end
end
function c100424021.repval(e,c)
	return c100424021.repfilter(c,e:GetHandlerPlayer())
end
