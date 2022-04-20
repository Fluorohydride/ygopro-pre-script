--ラヴェナス・ヴェンデット
--
--Script by Trishula9
function c101109064.initial_effect(c)
	aux.AddCodeList(c,101109040)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101109064+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101109064.target)
	e1:SetOperation(c101109064.activate)
	c:RegisterEffect(e1)
end
function c101109064.filter(c)
	return c:IsSetCard(0x106)
end
function c101109064.RitualUltimateFilter(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk,mc)
	if bit.band(c:GetType(),0x81)~=0x81 or (filter and not filter(c,e,tp,chk)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if m2 then
		mg:Merge(m2)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	local lv=level_function(c)
	Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(c,lv,greater_or_equal)
	local res=mg:CheckSubGroup(c101109064.rcheck,1,lv,tp,c,lv,greater_or_equal,mc)
	Auxiliary.GCheckAdditional=nil
	return res
end
function c101109064.rcheck(g,tp,c,lv,greater_or_equal,mc)
	return Auxiliary.RitualCheck(g,tp,c,lv,greater_or_equal) and g:IsContains(mc)
end
function c101109064.spfilter(c,e,tp)
	if not (c:IsSetCard(0x106) and not c:IsCode(101109040)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)) then return false end
	local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_MZONE)
	mg:AddCard(c)
	if c:IsLocation(LOCATION_GRAVE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_RITUAL_MATERIAL)
		e1:SetValue(1)
		c:RegisterEffect(e1)
		local res=Duel.IsExistingMatchingCard(c101109064.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,c101109064.filter,e,tp,mg,nil,Card.GetLevel,"Greater",true,c)
		e1:Reset()
		return res
	else
		return Duel.IsExistingMatchingCard(c101109064.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,c101109064.filter,e,tp,mg,nil,Card.GetLevel,"Greater",true,c)
	end
end
function c101109064.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101109064.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.IsPlayerCanSpecialSummonCount(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c101109064.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101109064.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)>0 then
		Duel.ConfirmCards(1-tp,sc)
		local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_MZONE)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101109064.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,c101109064.filter,e,tp,mg,nil,Card.GetLevel,"Greater",true,sc)
		local tc=tg:GetFirst()
		local mat
		if tc then
			Duel.BreakEffect()
			mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
			if tc.mat_filter then
				mg=mg:Filter(tc.mat_filter,tc,tp)
			else
				mg:RemoveCard(tc)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local lv=Card.GetLevel(tc)
			Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(tc,lv,"Greater")
			mat=mg:SelectSubGroup(tp,c101109064.rcheck,false,1,lv,tp,tc,lv,"Greater",sc)
			Auxiliary.GCheckAdditional=nil
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end
