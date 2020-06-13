--RR－ファントム・クロー
--Raidraptor - Phantom Knights' Claw
--Script by JoyJ
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
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
	local c=Duel.SelectMatchingCard(tp,c101102069.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
	local tc=Duel.GetOperatedGroup():GetFirst()
	if tc:IsSetCard(0xba) or tc:IsSetCard(0x10db) or tc:IsSetCard(0x2073) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c101102069.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c101102069.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xba) and c:IsType(TYPE_XYZ)
end
function c101102069.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 and e:GetLabel()==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local g=Duel.SelectMatchingCard(tp,c101102069.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.HintSelection(g)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(eg:GetFirst():GetBaseAttack())
			tc:RegisterEffect(e1)
		end
	end
end
