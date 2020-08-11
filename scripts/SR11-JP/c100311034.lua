--ドラグニティ・ヴォイド

--Scripted by mallu11
function c100311034.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,100311034+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100311034.condition)
	e1:SetTarget(c100311034.target)
	e1:SetOperation(c100311034.activate)
	c:RegisterEffect(e1)
end
function c100311034.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x29) and c:IsType(TYPE_SYNCHRO)
end
function c100311034.condition(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	return Duel.IsChainNegatable(ev) and Duel.IsExistingMatchingCard(c100311034.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c100311034.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c100311034.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x29)
end
function c100311034.cfilter(c)
	return c100311034.atkfilter(c) and c:IsLevel(10)
end
function c100311034.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)~=0 and eg:GetFirst():IsLocation(LOCATION_REMOVED) then
		local ct=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
		if Duel.IsExistingMatchingCard(c100311034.cfilter,tp,LOCATION_MZONE,0,1,nil) and ct>0 and Duel.SelectYesNo(tp,aux.Stringid(100311034,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local g=Duel.SelectMatchingCard(tp,c100311034.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
			Duel.HintSelection(g)
			local tc=g:GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(ct*100)
			tc:RegisterEffect(e1)
		end
	end
end
