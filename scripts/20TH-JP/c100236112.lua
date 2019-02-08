--師弟の絆
--
--Script by JoyJ
function c100236112.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100236112+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100236112.condition)
	e1:SetTarget(c100236112.target)
	e1:SetOperation(c100236112.activate)
	c:RegisterEffect(e1)
end
c100236112.card_code_list={46986414,38033121}
function c100236112.cfilter(c)
	return c:IsCode(46986414) and c:IsFaceup()
end
function c100236112.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100236112.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100236112.spfilter(c,e,tp)
	return c:IsCode(38033121) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100236112.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100236112.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c100236112.setfilter(c)
	return c:IsCode(2314238,75190122,49702428,100236109) and c:IsSSetable()
end
function c100236112.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100236112.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local sc=g:GetFirst()
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)>0 then
		local g2=Duel.GetMatchingGroup(c100236112.setfilter,tp,LOCATION_DECK,0,nil)
		if g2:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.SelectYesNo(tp,aux.Stringid(100236112,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local tc=g2:Select(tp,1,1,nil)
			Duel.SSet(tp,tc)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
