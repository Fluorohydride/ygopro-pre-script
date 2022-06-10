--ナチュル・モルクリケット
--
--Script by Trishula9
function c101110020.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101110020,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,101110020)
	e1:SetCondition(c101110020.spcon)
	e1:SetCost(c101110020.spcost)
	e1:SetTarget(c101110020.sptg)
	e1:SetOperation(c101110020.spop)
	c:RegisterEffect(e1)
	--revive
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101110020,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101110020+100)
	e2:SetCondition(c101110020.rvcon)
	e2:SetTarget(c101110020.rvtg)
	e2:SetOperation(c101110020.rvop)
	c:RegisterEffect(e2)
end
function c101110020.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c101110020.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fe=Duel.IsPlayerAffectedByEffect(tp,101110021)
	local b1=fe and Duel.IsPlayerCanDiscardDeckAsCost(tp,2)
	local b2=e:GetHandler():IsReleasable()
	if chk==0 then return b1 or b2 end
	if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(101110021,1))) and Duel.GetMZoneCount(tp)>0 then
		Duel.Hint(HINT_CARD,0,101110021)
		fe:UseCountLimit(tp)
		Duel.DiscardDeck(tp,2,REASON_COST)
	else
		Duel.Release(e:GetHandler(),REASON_COST)
	end
end
function c101110020.spfilter(c,e,tp)
	return c:IsSetCard(0x2a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101110020.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101110020.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101110020.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tg=g:GetMaxGroup(Card.GetAttack)
	if ft>=2 and not Duel.IsPlayerAffectedByEffect(tp,59822133) and tg and tg:IsExists(Card.IsControler,1,nil,1-tp) then ft=2
	else ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c101110020.spfilter,tp,LOCATION_DECK,0,1,ft,nil,e,tp)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101110020.cfilter(c,tp)
	return (c:IsSummonPlayer(1-tp) or c:IsSummonPlayer(tp) and c:IsSetCard(0x2a)) and c:IsSummonLocation(LOCATION_EXTRA)
end
function c101110020.rvcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101110020.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c101110020.rvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101110020.rvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end