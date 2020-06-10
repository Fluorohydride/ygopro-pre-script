--Raidraptor - Phantom Knights' Claw
function c101102069.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,101102069)
	e1:SetCondition(c101102069.condition)
	e1:SetCost(c101102069.cost)
	e1:SetTarget(c101102069.target)
	e1:SetOperation(c101102069.operation)
	c:RegisterEffect(e1)
end
function c101102069.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c101102069.cfilter(c,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_XYZ)
		and c:CheckRemoveOverlayCard(tp,1,REASON_COST)
end
function c101102069.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101102069.cfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101102069,0))
	local c=Duel.SelectMatchingCard(tp,c101102069.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	local g2=c:GetOverlayGroup()
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
	local g3=c:GetOverlayGroup()
	g2:Sub(g3)
	local tc=g2:GetFirst()
	if tc:IsSetCard(0xba) or tc:IsSetCard(0x10db) or tc:IsSetCard(0x2073) then
		e:SetLabel(tc:GetBaseAttack())
	else
		e:SetLabel(0)
	end
end
function c101102069.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xba) and c:IsType(TYPE_XYZ)
end
function c101102069.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c101102069.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 and e:GetLabel()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectMatchingCard(tp,c101102069.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
		if g then
			local tc=g:GetFirst()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(e:Getlabel())
			c:RegisterEffect(e1)
		end
	end
end












