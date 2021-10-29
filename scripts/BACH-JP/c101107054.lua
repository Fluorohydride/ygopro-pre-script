--凶導の葬列
--
--Script by JoyJ
function c101107054.initial_effect(c)
	aux.AddCodeList(c,40352445,101107035)
	local e1=aux.AddRitualProcGreater2(c,c101107054.filter,LOCATION_HAND+LOCATION_GRAVE,c101107054.grfilter,nil,true)
	e1:SetCountLimit(1,101107054+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c101107054.operation)
	c:RegisterEffect(e1)
end
function c101107054.filter(c)
	return c:IsSetCard(0x145)
end
function c101107054.grfilter(c)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO)
end
function c101107054.opfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c101107054.operation(e,tp,eg,ep,ev,re,r,rp)
	local filter=c101107054.filter
	local level_function=Card.GetLevel
	local greater_or_equal="Greater"
	local summon_location=LOCATION_HAND+LOCATION_GRAVE
	local grave_filter=c101107054.grfilter
	local mat_filter=nil
	--ritual summon
	local mg=Duel.GetRitualMaterial(tp)
	if mat_filter then mg=mg:Filter(mat_filter,nil,e,tp) end
	local exg=nil
	if grave_filter then
		exg=Duel.GetMatchingGroup(Auxiliary.RitualExtraFilter,tp,LOCATION_GRAVE,0,nil,grave_filter)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,Auxiliary.NecroValleyFilter(Auxiliary.RitualUltimateFilter),tp,summon_location,0,1,1,nil,filter,e,tp,mg,exg,level_function,greater_or_equal)
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if exg then
			mg:Merge(exg)
		end
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local lv=level_function(tc)
		Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(tc,lv,greater_or_equal)
		local mat=mg:SelectSubGroup(tp,Auxiliary.RitualCheck,false,1,lv,tp,tc,lv,greater_or_equal)
		Auxiliary.GCheckAdditional=nil
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
	--confirm
	local g1=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if Duel.IsExistingMatchingCard(c101107054.opfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,40352445)
		and Duel.IsExistingMatchingCard(c101107054.opfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,101107035) 
		and (#g1~=0 or #g2~=0) and Duel.SelectYesNo(tp,aux.Stringid(101107054,2)) then
		Duel.BreakEffect()
		local g=nil
		if #g1~=0 and (#g2==0 or Duel.SelectOption(tp,aux.Stringid(101107054,0),aux.Stringid(101107054,1))==0) then
			g=g1
		else
			g=g2
		end
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=g:FilterSelect(tp,Card.IsAbleToGrave,1,1,nil)
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
