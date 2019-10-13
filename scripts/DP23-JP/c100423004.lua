--黒魔術の秘儀

--Scripted by mallu11
function c100423004.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,100423004+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100423004.target)
	e1:SetOperation(c100423004.activate)
	c:RegisterEffect(e1)
end
c100423004.card_code_list={46986414,38033121}
function c100423004.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c100423004.filter2(c,e,tp,m,f,gc,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
	and c:CheckFusionMaterial(m,gc,chkf)
end
function c100423004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=nil
	local tc=nil
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp)
	local mg2=nil
	g=mg1:Filter(Card.IsCode,nil,46986414,38033121)
	local res1=false
	gc=g:GetFirst()
	while gc do
		res1=res1 or Duel.IsExistingMatchingCard(c100423004.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,gc,chkf)
		gc=g:GetNext()
	end
	if not res1 then
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			local mg3=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			g=mg3:Filter(Card.IsCode,nil,46986414,38033121)
			gc=g:GetFirst()
			while gc do
				res1=res1 or Duel.IsExistingMatchingCard(c100423004.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,gc,chkf)
				gc=g:GetNext()
			end
		end
	end
	local mg=Duel.GetRitualMaterial(tp)
	local sg=nil
	g=mg:Filter(Card.IsCode,nil,46986414,38033121)
	local res2=false
	gc=g:GetFirst()
	while gc do
		res2=res2 or Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,aux.TRUE,e,tp,mg,sg,Card.GetLevel,"Greater",gc)
		gc=g:GetNext()
	end
	if chk==0 then
		return res1 or res2
	end
	local s=0
	if res1 and not res2 then
		s=Duel.SelectOption(tp,aux.Stringid(100423004,0))
	end
	if not res1 and res2 then
		s=Duel.SelectOption(tp,aux.Stringid(100423004,1))+1
	end
	if res1 and res2 then
		s=Duel.SelectOption(tp,aux.Stringid(100423004,0),aux.Stringid(100423004,1))
	end
	e:SetLabel(s)
	if s==0 then
		local cat=e:GetCategory()
		e:SetCategory(bit.bor(cat,CATEGORY_FUSION_SUMMON))
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
	if s==1 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	end
end
function c100423004.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=nil
	local gc=nil
	if e:GetLabel()==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c100423004.filter1,nil,e)
		local mg2=nil
		g=mg1:Filter(Card.IsCode,nil,46986414,38033121)
		gc=g:GetFirst()
		local sg1=Group.CreateGroup()
		while gc do
			sg1:Merge(Duel.GetMatchingGroup(c100423004.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,gc,chkf))
			if not Duel.IsExistingMatchingCard(c100423004.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,gc,chkf) then
				mg1:RemoveCard(gc)
			end
			gc=g:GetNext()
		end
		local mg3=nil
		local sg2=nil
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			mg3=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			g=mg3:Filter(Card.IsCode,nil,46986414,38033121)
			gc=g:GetFirst()
			local sg2=Group.CreateGroup()
			while gc do
				sg2:Merge(Duel.GetMatchingGroup(c100423004.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,gc,chkf))
				if not Duel.IsExistingMatchingCard(c100423004.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,nil,gc,chkf) then
					mg3:RemoveCard(gc)
				end
				gc=g:GetNext()
			end
		end
		if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
			local sg=sg1:Clone()
			if sg2 then sg:Merge(sg2) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=sg:Select(tp,1,1,nil)
			local tc=tg:GetFirst()
			if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
				g=mg1:Filter(Card.IsCode,nil,46986414,38033121)
				gc=g:GetFirst()
				local pg=Group.CreateGroup()
				while gc do
					if tc:CheckFusionMaterial(mg1,gc,chkf) then
						pg:AddCard(gc)
					end
					gc=g:GetNext()
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				g=pg:Select(tp,1,1,nil)
				Duel.SetSelectedCard(g:GetFirst())
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
				tc:SetMaterial(mat1)
				Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			else
				g=mg3:Filter(Card.IsCode,nil,46986414,38033121)
				gc=g:GetFirst()
				local pg=nil
				while gc do
					if tc:CheckFusionMaterial(mg3,gc,chkf) then
						pg:AddCard(gc)
					end
					gc=g:GetNext()
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				g=pg:Select(tp,1,1,nil)
				Duel.SetSelectedCard(g:GetFirst())
				local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
				local fop=ce:GetOperation()
				fop(ce,e,tp,tc,mat2)
			end
			tc:CompleteProcedure()
		end
	end
	if e:GetLabel()==1 then
		local mg=Duel.GetRitualMaterial(tp)
		local sg=nil
		g=mg:Filter(Card.IsCode,nil,46986414,38033121)
		local sg1=Group.CreateGroup()
		gc=g:GetFirst()
		while gc do
			sg1:Merge(Duel.GetMatchingGroup(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,nil,aux.TRUE,e,tp,mg,sg,Card.GetLevel,"Greater",gc))
			if not Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,aux.TRUE,e,tp,mg,sg,Card.GetLevel,"Greater",gc) then
				mg:RemoveCard(gc)
			end
			gc=g:GetNext()
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg1:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if tc then
			mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
			if sg then
				mg:Merge(sg)
			end
			if tc.mat_filter then
				mg=mg:Filter(tc.mat_filter,tc,tp)
			else
				mg:RemoveCard(tc)
			end
			g=mg:Filter(Card.IsCode,nil,46986414,38033121)
			gc=g:Select(tp,1,1,nil):GetFirst()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			Duel.SetSelectedCard(gc)
			aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
			local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
			aux.GCheckAdditional=nil
			if not mat or mat:GetCount()==0 then return end
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end
