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
	return (c:IsSetCard(0x266) and c:IsType(TYPE_RITUAL) or c:IsSetCard(0x18f) and c:IsType(TYPE_MONSTER) and c:IsSummonLocation(LOCATION_EXTRA)) 
end
function c101105073.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c101105073.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep~=tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
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
	if Duel.NegateActivation(ev)~=0 and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)
		and Duel.SelectYesNo(tp,aux.Stringid(101105073,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
		local rc=Duel.AnnounceAttribute(tp,1,0xffff)
		e:SetLabel(rc)
		local g=Duel.GetMatchingGroup(c101105073.attfilter,tp,0,LOCATION_MZONE,nil)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(e:GetLabel())
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end
end
