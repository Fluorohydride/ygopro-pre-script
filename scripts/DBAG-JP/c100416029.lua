--ベアルクティ－ミクビリス

--Scripted by mallu11
function c100416029.initial_effect(c)
	--spsummon
	local e1=aux.AddUrsarcticSpSummonEffect(c)
	e1:SetDescription(aux.Stringid(100416029,0))
	e1:SetCountLimit(1,100416029)
	--spsummon2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100416029,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,100416029+100)
	e2:SetTarget(c100416029.sptg2)
	e2:SetOperation(c100416029.spop2)
	c:RegisterEffect(e2)
end
if Auxiliary.AddUrsarcticSpSummonEffect==nil then
--Ursarctic common summon from hand effect
function Auxiliary.AddUrsarcticSpSummonEffect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCondition(Auxiliary.UrsarcticSpSummonCondition)
	e1:SetCost(Auxiliary.UrsarcticSpSummonCost)
	e1:SetTarget(Auxiliary.UrsarcticSpSummonTarget)
	e1:SetOperation(Auxiliary.UrsarcticSpSummonOperation)
	c:RegisterEffect(e1)
	return e1
end
function Auxiliary.UrsarcticSpSummonCondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function Auxiliary.UrsarcticReleaseFilter(c,tp)
	return c:IsLevelAbove(7) and (c:IsControler(tp) and c:IsLocation(LOCATION_HAND) or c:IsFaceup() and c:IsControler(1-tp))
end
function Auxiliary.UrsarcticExCostFilter(c,tp)
	return c:IsAbleToRemoveAsCost() and (c:IsHasEffect(100416036,tp) or c:IsHasEffect(100416038,tp))
end
function Auxiliary.UrsarcticSpSummonCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetReleaseGroup(tp,true):Filter(Auxiliary.UrsarcticReleaseFilter,e:GetHandler(),tp)
	local g2=Duel.GetMatchingGroup(Auxiliary.UrsarcticExCostFilter,tp,LOCATION_GRAVE,0,nil,tp)
	g1:Merge(g2)
	if chk==0 then return g1:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g1:Select(tp,1,1,nil):GetFirst()
	local te=tc:IsHasEffect(100416036,tp) or tc:IsHasEffect(100416038,tp)
	if te then
		te:UseCountLimit(tp)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
	else
		Duel.Release(tc,REASON_COST)
	end
end
function Auxiliary.UrsarcticSpSummonTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function Auxiliary.UrsarcticSpSummonOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(Auxiliary.UrsarcticSpSummonLimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function Auxiliary.UrsarcticSpSummonLimit(e,c)
	return c:IsLevel(0)
end
end
function c100416029.spfilter2(c,e,tp)
	return c:IsSetCard(0x261) and not c:IsCode(100416029) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100416029.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c100416029.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c100416029.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100416029.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
