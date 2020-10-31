--Myutant GB-88
function c101102086.initial_effect(c)
	--self spsummon
	local e1=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101102086,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101102086)
	e1:SetCondition(c101102086.spcon)
	e1:SetTarget(c101102086.sptg)
	e1:SetOperation(c101102086.spop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101102086,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,101102086+100)
	e2:SetTarget(c101102086.sp2cost)
	e2:SetTarget(c101102086.sp2tg)
	e2:SetOperation(c101102086.sp2op)
	c:RegisterEffect(e2)
end
function c101102086.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c101102086.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetMZoneCount(tp)>0
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101102086.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c101102086.sp2costfilter(c)
	return c:IsAbleToRemoveAsCost() and (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
end
function c101102086.sp2cost(e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then return e:GetHandler():IsReleasable()
		and Duel.IsExistingMatchingCard(c101102086.sp2costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil,e,tp) end
	Duel.Release(e:GetHandler(),REASON_COST+REASON_RELEASE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cost=Duel.SelectMatchingCard(tp,c101102086.sp2costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,e,tp)
	Duel.Remove(cost,POS_FACEUP,REASON_COST)
end
function c101102086.sp2tgfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsSetCard(0x258) and c:IsLevel(8)
end
function c101102086.sp2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101102086.sp2tgfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c101102086.sp2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c101102086.sp2costfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if tc then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
end