--星遺物の囁き
--Whisper of the World Legacy
--Script by nekrozar
function c101003071.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetTarget(c101003071.target)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c101003071.discon)
	e2:SetOperation(c101003071.disop)
	c:RegisterEffect(e2)
end
function c101003071.atkfilter(c)
	return c:IsFaceup() and c:IsLevelBelow(6)
end
function c101003071.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101003071.atkfilter(chkc) end
	if chk==0 then
		if Duel.GetCurrentPhase()==PHASE_DAMAGE then
			return Duel.IsExistingTarget(c101003071.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		end
		return true
	end
	if Duel.GetCurrentPhase()==PHASE_DAMAGE
		or (Duel.IsExistingTarget(c101003071.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(101003071,0))) then
		e:SetCategory(CATEGORY_ATKCHANGE)
		e:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(c101003071.activate)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c101003071.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	else
		e:SetCategory(0)
		e:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e:SetOperation(nil)
	end
end
function c101003071.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end
function c101003071.cfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x20c)
end
function c101003071.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsActiveType(TYPE_SPELL) and re:GetHandler():GetColumnGroup():FilterCount(c101003071.cfilter,nil,tp)>0
end
function c101003071.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
