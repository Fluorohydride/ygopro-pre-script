--巡掠海魔船 利斯号
function c101012087.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,Card.IsSetCard,2,false,0x13f)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101012087,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101012087)
	e1:SetCondition(c101012087.spcon)
	e1:SetTarget(c101012087.sptg)
	e1:SetOperation(c101012087.spop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27346636,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101012087+100)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c101012087.discon)
	e2:SetCost(c101012087.discost)
	e2:SetTarget(c101012087.distg)
	e2:SetOperation(c101012087.disop)
	c:RegisterEffect(e2)
end

function c101012087.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c101012087.spfilter(c,e,tp)
	return c:IsSetCard(0x13f) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101012087.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101012087.spfilter,tp,LOCATION_SZONE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_SZONE+LOCATION_HAND)
end
function c101012087.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,c101012087.spfilter,tp,LOCATION_SZONE+LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end
function c101012087.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c101012087.discfilter(c)
	return c:IsDiscardable() and c:IsSetCard(0x13f)
end
function c101012087.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101012087.discfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c101012087.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c101012087.thfilter(c)
	return c:IsSetCard(0x13f) and c:IsAbleToHand()
end
function c101012087.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() or not c:IsRelateToEffect(e) then return end
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re)
		and Duel.Destroy(eg,REASON_EFFECT)>0
		and c:GetEquipGroup()
		and c:GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x13f)
		and Duel.IsExistingMatchingCard(c101012087.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(101012087,2)) then
		local c=Duel.SelectMatchingCard(tp,c101012087.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end