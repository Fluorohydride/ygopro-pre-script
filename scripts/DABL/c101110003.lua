--BF-雪撃のチヌーク
function c101110003.initial_effect(c)
	--- has dragon in content
	aux.AddCodeList(c, 9012916)

	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101110003,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,101110003)
	e1:SetCondition(c101110003.con)
	e1:SetCost(c101110003.cost)
	e1:SetTarget(c101110003.target)
	e1:SetOperation(c101110003.operate)
	c:RegisterEffect(e1)

	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c101110003.quickCon)
	c:RegisterEffect(e2)
end

function c101110003.quickConFilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_DARK)
end

function c101110003.toGraveFilter(c)
	local isRightCode = (c:IsSetCard(0x33) and c:IsType(TYPE_SYNCHRO)) or c:IsCode(9012916)
	return isRightCode and c:IsAbleToGrave()
end

function c101110003.targetFilter(c)
	return c:IsFaceup()
end

function c101110003.con(e,tp,eg,ep,ev,re,r,rp) 
	-- enenemy, counter enough, has card to destory
	if not e:GetHandler():IsAbleToGraveAsCost() then
		return false
	end

	local hasDarkSyn = Duel.IsExistingMatchingCard(c101110003.quickConFilter, tp, LOCATION_MZONE,0, 1, nil)
	local hasTarget = Duel.IsExistingMatchingCard(c101110003.targetFilter, tp, 0,LOCATION_MZONE, 1, nil)
	local hasToGrave = Duel.IsExistingMatchingCard(c101110003.toGraveFilter, tp, LOCATION_EXTRA, 0, 1, nil)

	return (not hasDarkSyn) and hasTarget and hasToGrave 
end

function c101110003.quickCon(e,tp,eg,ep,ev,re,r,rp) 
	-- enenemy, counter enough, has card to destory
	if not e:GetHandler():IsAbleToGraveAsCost() then
		return false
	end

	local hasDarkSyn = Duel.IsExistingMatchingCard(c101110003.quickConFilter, tp, LOCATION_MZONE,0, 1, nil)
	local hasTarget = Duel.IsExistingMatchingCard(c101110003.targetFilter, tp, 0,LOCATION_MZONE, 1, nil)
	local hasToGrave = Duel.IsExistingMatchingCard(c101110003.toGraveFilter, tp, LOCATION_EXTRA, 0, 1, nil)

	return hasDarkSyn and hasTarget and hasToGrave		  
end


function c101110003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end

function c101110003.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then 
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c101110003.targetFilter(chkc) 
	end
	if chk==0 then 
		return Duel.IsExistingTarget(c101110003.targetFilter,tp,0,LOCATION_MZONE,1,nil) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101110003.targetFilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c101110003.operate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp, c101110003.toGraveFilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE) then
		local c = e:GetHandler()
		local tc=Duel.GetFirstTarget()
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(-700)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
end