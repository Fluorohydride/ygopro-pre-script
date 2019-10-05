--Dream Mirror Oneiromancy

--Scripted by mallu11
function c101010091.initial_effect(c)
	--activate(effect)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,101010091+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101010091.condition1)
	e1:SetTarget(c101010091.target1)
	e1:SetOperation(c101010091.activate1)
	c:RegisterEffect(e1)
	--activate(spsummon)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetCountLimit(1,101010091+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c101010091.condition2)
	e2:SetTarget(c101010091.target2)
	e2:SetOperation(c101010091.activate2)
	c:RegisterEffect(e2)
end
function c101010091.cfilter1(c)
	return c:IsFaceup() and c:IsCode(74665651)
end
function c101010091.condition1(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev) and rp==1-tp and Duel.IsExistingMatchingCard(c101010091.cfilter1,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function c101010091.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c101010091.activate1(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end
function c101010091.cfilter2(c)
	return c:IsFaceup() and c:IsCode(1050355)
end
function c101010091.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and rp==1-tp and Duel.IsExistingMatchingCard(c101010091.cfilter2,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function c101010091.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c101010091.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
