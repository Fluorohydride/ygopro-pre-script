--タキオン・ギャラクシースパイラル

--Scripted by nekrozar
function c101010073.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101010073+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101010073.target)
	e1:SetOperation(c101010073.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c101010073.handcon)
	c:RegisterEffect(e2)
end
function c101010073.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x7b) and c:IsRace(RACE_DRAGON)
end
function c101010073.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101010073.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101010073.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101010073.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101010073.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetValue(c101010073.efilter)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c101010073.efilter(e,re)
	return e:GetHandler()~=re:GetOwner()
end
function c101010073.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x307b)
end
function c101010073.handcon(e)
	return Duel.IsExistingMatchingCard(c101010073.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
