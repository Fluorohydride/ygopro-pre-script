--S－Force オリフィス

--Scripted by mallu11
function c101103013.initial_effect(c)
	--can not be effect target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c101103013.ettg)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101103013,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101103013)
	e2:SetCondition(c101103013.descon)
	e2:SetCost(c101103013.descost)
	e2:SetTarget(c101103013.destg)
	e2:SetOperation(c101103013.desop)
	c:RegisterEffect(e2)
end
function c101103013.etfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x259) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c101103013.ettg(e,c)
	local cg=c:GetColumnGroup()
	return cg:IsExists(c101103013.etfilter,1,nil,e:GetHandlerPlayer())
end
function c101103013.descon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsLocation(LOCATION_MZONE) and re:IsActiveType(TYPE_MONSTER) and rp==1-tp
end
function c101103013.costfilter(c)
	return c:IsSetCard(0x259) and c:IsAbleToRemoveAsCost()
end
function c101103013.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101103013.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101103013.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101103013.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function c101103013.desop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
