--魔鍵錠－解－
--Magikey Unlocked
--scripted by XyleN5967
function c101105073.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,101105073+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101105073.condition)
	e1:SetTarget(c101105073.target)
	e1:SetOperation(c101105073.activate)
	c:RegisterEffect(e1)
end
function c101105073.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x165) and (c:IsType(TYPE_RITUAL) or c:IsSummonLocation(LOCATION_EXTRA))
end
function c101105073.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c101105073.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	return ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c101105073.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c101105073.attfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c101105073.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0
		and Duel.SelectYesNo(tp,aux.Stringid(101105073,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
		local attr=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetValue(attr)
		Duel.RegisterEffect(e1,tp)
	end
end
