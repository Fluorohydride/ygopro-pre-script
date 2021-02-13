--冥界の呼び較

--scripted by Xylen5967
function c100416013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetTarget(c100416013.target)
	e1:SetOperation(c100416013.operation)
	c:RegisterEffect(e1)
end
function c100416013.spfilter(c,e,tp)
	return c:IsRace(RACE_REPTILE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100416013.cfilter(c)
	return c:IsSetCard(0x264) and c:IsType(TYPE_MONSTER)
end
function c100416013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local sub=Duel.GetMatchingGroup(c100416013.cfilter,tp,LOCATION_GRAVE,0,nil)
	local res=sub:GetClassCount(Card.GetCode)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,100416111,0,0x4011,0,0,2,RACE_REPTILE,ATTRIBUTE_DARK)
		or res>=8 and Duel.IsExistingMatchingCard(c100416013.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c100416013.operation(e,tp,eg,ep,ev,re,r,rp)
	local sub=Duel.GetMatchingGroup(c100416013.cfilter,tp,LOCATION_GRAVE,0,nil)
	local res=sub:GetClassCount(Card.GetCode)
	if res>=8 and Duel.IsExistingMatchingCard(c100416013.spfilter,tp,LOCATION_GRAVE,0,2,nil,e,tp) and (not Duel.IsPlayerCanSpecialSummonMonster(tp,100416113,0,0x4011,0,0,2,RACE_REPTILE,ATTRIBUTE_DARK) or Duel.SelectYesNo(tp,aux.Stringid(100416013,0))) then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100416013.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
		if #g>=2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
		if not Duel.IsPlayerCanSpecialSummonMonster(tp,100416113,0,0x4011,0,0,2,RACE_REPTILE,ATTRIBUTE_DARK) then return end
		for i=1,2 do
			local token=Duel.CreateToken(tp,100416113)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
end
