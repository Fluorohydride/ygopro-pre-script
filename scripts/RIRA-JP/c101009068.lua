--海晶少女波动
function c101009068.initial_effect(c)
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCondition(c101009068.con)
	e1:SetTarget(c101009068.target)
	e1:SetOperation(c101009068.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c101009068.handcon)
	c:RegisterEffect(e2)
end
function c101009068.rccfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x22b) and c:IsType(TYPE_LINK)
end
function c101009068.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x22b) and c:IsLinkAbove(2)
end
function c101009068.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101009068.rccfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c101009068.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c101009068.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c101009068.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101009068.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101009068.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c101009068.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsDisabled() and tc:IsControler(1-tp) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		end
		local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,sc)
		g1:RemoveCard(c)
		if Duel.IsExistingMatchingCard(c101009068.cfilter,tp,LOCATION_MZONE,0,1,nil) and g1:GetCount()>0 then
			Duel.BreakEffect()
		end
		local nc=g1:GetFirst()
		while nc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(c101009068.efilter)
		e1:SetOwnerPlayer(tp)
		nc:RegisterEffect(e1)
		nc=g1:GetNext()
	end
end
function c101009068.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c101009068.ccfilter(c)
	return c:IsSetCard(0x22b) and c:IsLinkAbove(3)
end
function c101009068.handcon(e)
	return Duel.IsExistingMatchingCard(c101009069.rccfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end