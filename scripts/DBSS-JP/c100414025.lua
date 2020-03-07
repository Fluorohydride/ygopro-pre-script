--六花深々

--Scripted by mallu11
function c100414025.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100414025,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,100414025+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100414025.target)
	e1:SetOperation(c100414025.activate)
	c:RegisterEffect(e1)
	--cost
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100414025,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,100414025+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c100414025.cost)
	e2:SetTarget(c100414025.target2)
	e2:SetOperation(c100414025.activate2)
	c:RegisterEffect(e2)
end
function c100414025.spfilter(c,e,tp,check)
	return c:IsSetCard(0x245) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
		and (check or Duel.IsExistingMatchingCard(c100414025.spfilter2,tp,LOCATION_GRAVE,0,1,c,e,tp))
end
function c100414025.spfilter2(c,e,tp)
	return c:IsRace(RACE_PLANT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c100414025.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c100414025.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,true)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c100414025.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100414025.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,true)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c100414025.rfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>1 and c:IsRace(RACE_PLANT)
end
function c100414025.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c100414025.rfilter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c100414025.rfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c100414025.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=e:GetLabel()==1 or Duel.GetLocationCount(tp,LOCATION_MZONE)>1
	if chk==0 then
		e:SetLabel(0)
		return res and e:IsHasType(EFFECT_TYPE_ACTIVATE)
			and Duel.IsExistingMatchingCard(c100414025.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
			and Duel.IsPlayerCanSpecialSummonCount(tp,2)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end
function c100414025.activate2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100414025.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,true)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
		if e:IsHasType(EFFECT_TYPE_ACTIVATE)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c100414025.spfilter2),tp,LOCATION_GRAVE,0,1,nil,e,tp) then
			Duel.BreakEffect()
			local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100414025.spfilter2),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end

