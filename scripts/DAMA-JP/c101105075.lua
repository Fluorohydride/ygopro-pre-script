--先史遺産石紋
--
--Script by JustFish
function c101105075.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCountLimit(1,101105075+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101105075.condition)
	e1:SetTarget(c101105075.target)
	e1:SetOperation(c101105075.activate)
	c:RegisterEffect(e1)
end
function c101105075.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c101105075.tgfilter(c,e,tp)
	if c:GetOriginalType()&TYPE_XYZ==0 or c:IsFacedown() or not c:IsCanBeEffectTarget(e) then return false end
	local mg=Duel.GetMatchingGroup(c101105075.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp,c:GetRank())
	return Duel.IsExistingMatchingCard(c101105075.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg)
end
function c101105075.spfilter(c,e,tp,rk)
	return c:IsLevel(rk+1) and c:IsSetCard(0x70) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101105075.xyzfilter(c,e,tp,mg)
	return c:IsSetCard(0x70) and c:IsXyzSummonable(mg,2,2) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c101105075.mfilter1(c,mg,exg)
	return mg:IsExists(c101105075.mfilter2,1,c,c,exg)
end
function c101105075.mfilter2(c,mc,exg)
	return exg:IsExists(Card.IsXyzSummonable,1,nil,Group.FromCards(c,mc))
end
function c101105075.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and c101105075.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingTarget(c101105075.tgfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c101105075.tgfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function c101105075.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c101105075.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp,tc:GetRank())
	local exg=Duel.GetMatchingGroup(c101105075.xyzfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=mg:FilterSelect(tp,c101105075.mfilter1,1,1,nil,mg,exg)
	local tc1=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=mg:FilterSelect(tp,c101105075.mfilter2,1,1,tc1,tc1,exg)
	g1:Merge(g2)
	if g1:GetCount()<2 then return end
	local tc=g1:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		tc=g1:GetNext()
	end
	Duel.SpecialSummonComplete()
	Duel.RaiseEvent(e:GetHandler(),EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
	if g1:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<2 then return end
	local xyzg=Duel.GetMatchingGroup(c101105075.xyzfilter,tp,LOCATION_EXTRA,0,nil,e,tp,g1)
	if #xyzg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g1)
	end
end
