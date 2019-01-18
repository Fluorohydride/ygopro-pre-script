--断罪の呪眼
--
--Scripted by Maru
function c100412039.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,100412039+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100412039.condition)
	e1:SetTarget(c100412039.target)
	e1:SetOperation(c100412039.activate)
	c:RegisterEffect(e1)
end
function c100412039.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x226)
end
function c100412039.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
		and Duel.IsExistingMatchingCard(c100412039.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100412039.filter(c)
	return c:IsFaceup() and c:IsCode(100412032)
end
function c100412039.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.IsExistingMatchingCard(c100412039.filter,tp,LOCATION_SZONE,0,1,nil) then
		e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	else
		e:SetProperty(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c100412039.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
