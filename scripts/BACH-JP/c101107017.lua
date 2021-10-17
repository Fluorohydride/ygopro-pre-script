--治安战警队 追溯者
function c101107017.initial_effect(c)
	--hand link
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101107017)
	e1:SetValue(c101107017.matval)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101107017,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,101107017+100)
	e2:SetCondition(c101107017.spcon)
	e2:SetTarget(c101107017.sptg)
	e2:SetOperation(c101107017.spop)
	c:RegisterEffect(e2)
	--banish replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(55049722) --eventually not wrong
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,101107017+200)
	c:RegisterEffect(e3)
end
function c101107017.spfilter(c,e,tp)
	return c:IsSetCard(0x156) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101107017.spcon(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) then return false end
end
function c101107017.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(c101107017.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		and e:GetHandler():IsAbletoHand() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c101107017.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SendtoHand(c,nil,REASON_EFFECT) then
		local g=Duel.SelectMatchingCard(tp,c101107017.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101107017.mfilter(c)
	return c:IsLocation(LOCATION_MZONE)
end
function c101107017.exmfilter(c)
	return c:IsLocation(LOCATION_HAND) and c:IsCode(101107017)
end
function c101107017.matval(e,lc,mg,c,tp)
	if not lc:IsSetCard(0x156) then return false,nil end
	return true,not mg or mg:IsExists(c101107017.mfilter,1,nil) and not mg:IsExists(c101107017.exmfilter,1,nil)
end