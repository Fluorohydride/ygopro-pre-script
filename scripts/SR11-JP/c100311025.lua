--疾风之龙骑兵团
function c100311025.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100311025+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100311025.condition)
	e1:SetTarget(c100311025.target)
	e1:SetOperation(c100311025.activate)
	c:RegisterEffect(e1)
end
function c100311025.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c100311025.filter1(c,e,tp)
	return c:IsSetCard(0x29) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100311025.filter2(c,e,tp)
	return c:IsSetCard(0x29) and c:IsRace(RACE_WINDBEAST) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100311025.filter3(c,e,tp)
	return c:IsSetCard(0x29) and (c:IsRace(RACE_WINDBEAST) or c:IsType(TYPE_TUNER)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100311025.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c100311025.filter1,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c100311025.filter2,tp,LOCATION_DECK,0,1,nil,e,tp)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c100311025.gcheck(g)
	if #g~=2 then return false end
	local ca=g:GetFirst()
	local cb=g:GetNext()
	return c100311025.filter1(ca) and c100311025.filter2(cb) or c100311025.filter1(cb) and c100311025.filter2(ca)
end
function c100311025.scfilter(c,mg)
	return c:IsRace(RACE_DRAGON) and c:IsSynchroSummonable(nil,mg)
end
function c100311025.cfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c100311025.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c100311025.filter3,tp,LOCATION_DECK,0,nil,e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 or g:CheckSubGroup(c100311025.gcheck,2,2) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c100311025.gcheck,false,2,2)
	local ca=g:GetFirst()
	local cb=g:GetNext()
	local success=false
	if Duel.SpecialSummonStep(ca,0,tp,tp,false,false,POS_FACEUP) and Duel.SpecialSummonStep(cb,0,tp,tp,false,false,POS_FACEUP) then
		success=true
		local e1=Effect.CreateEffect(ca)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		ca:RegisterEffect(e1)
		local e2=Effect.CreateEffect(ca)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		ca:RegisterEffect(e2)
		local e3=e1:Clone()
		cb:RegisterEffect(e3)
		local e4=e2:Clone()
		cb:RegisterEffect(e4)
	end
	Duel.SpecialSummonComplete()
	local mg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x29)
	if success and Duel.IsExistingMatchingCard(c100311025.cfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c100311025.scfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
		and Duel.SelectYesNo(tp,aux.Stringid(100311025,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,c100311025.scfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg)
		Duel.SynchroSummon(tp,tc,nil,mg)
	end
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c100311025.splimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c100311025.splimit(e,c)
	return not c:IsRace(RACE_DRAGON) and c:IsLocation(LOCATION_EXTRA)
end
