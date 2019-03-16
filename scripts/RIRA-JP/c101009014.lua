--天威龍－マニラ
--
--scripted by JoyJ
function c101009014.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101009014,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101009014)
	e1:SetCondition(c101009014.spcon)
	e1:SetTarget(c101009014.sptg)
	e1:SetOperation(c101009014.spop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101009014,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,101009014+100)
	e2:SetCondition(c101009014.negcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101009014.negtg)
	e2:SetOperation(c101009014.negop)
	c:RegisterEffect(e2)
end
function c101009014.spcfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup()
end
function c101009014.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c101009014.spcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101009014.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101009014.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101009014.negcfilter(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_EFFECT) and c:IsFaceup()
end
function c101009014.negcon(e,tp,eg,ep,ev,re,r,rp)
	if rp==1-tp and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		return tg and tg:IsExists(c101009014.negcfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
	end
	return false
end
function c101009014.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c101009014.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
