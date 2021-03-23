--繋がれし魔鍵
--
--scripted by zerovoros a.k.a faultzone & XyleN5967
function c101105072.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101105072.target)
	e1:SetOperation(c101105072.activate)
	c:RegisterEffect(e1)
end
function c101105072.thfilter(c)
	return (c:IsType(TYPE_NORMAL) or c:IsSetCard(0x266)) and c:IsAbleToHand()
end
function c101105072.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101105072.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101105072.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101105072.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101105072.fusfilter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c101105072.fusfilter2(c,e,tp,m,f,gc,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x266) and (not f or f(c)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c101105072.ritfilter(e,tp)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0x266)
end
function c101105072.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local res1=Duel.IsExistingMatchingCard(c101105072.fusfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res1 then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res1=Duel.IsExistingMatchingCard(c101105072.fusfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		aux.FCheckAdditional=nil
		local mg3=Duel.GetRitualMaterial(tp)
		local res2=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,c101105072.ritfilter,e,tp,mg3,nil,Card.GetLevel,"Greater")
		aux.RCheckAdditional=nil
		local s=0
		if res1 and not res2 then
			s=Duel.SelectOption(tp,aux.Stringid(101105072,0))
		end
		if not res1 and res2 then
			s=Duel.SelectOption(tp,aux.Stringid(101105072,1))+1
		end
		if res1 and res2 then
			s=Duel.SelectOption(tp,aux.Stringid(101105072,0),aux.Stringid(101105072,1))
		end
		e:SetLabel(s)
		if s==0 then
			local chkf=tp
			local mg1=Duel.GetFusionMaterial(tp)
			local sg1=Duel.GetMatchingGroup(c101105072.fusfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
			local mg2=nil
			local sg2=nil
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				sg2=Duel.GetMatchingGroup(c101105072.fusfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
			end
			if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
				local sg=sg1:Clone()
				if sg2 then sg:Merge(sg2) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=sg:Select(tp,1,1,nil)
				local tc=tg:GetFirst()
				if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
					local mat=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
					tc:SetMaterial(mat)
					Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
				else
					local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
					local fop=ce:GetOperation()
					fop(ce,e,tp,tc,mat2)
				end
				tc:CompleteProcedure()
			end
			aux.FCheckAdditional=nil
		elseif s==1 then
			local mg=Duel.GetRitualMaterial(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,1,nil,c101105072.ritfilter,e,tp,mg,nil,Card.GetLevel,"Greater")
			local tc=tg:GetFirst()
			if tc then
				mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
				if tc.mat_filter then
					mg=mg:Filter(tc.mat_filter,tc,tp)
				else
					mg:RemoveCard(tc)
				end
				aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
				local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
				aux.GCheckAdditional=nil
				if not mat or mat:GetCount()==0 then
					aux.RCheckAdditional=nil
					return
				end
				tc:SetMaterial(mat)
				Duel.ReleaseRitualMaterial(mat)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
				tc:CompleteProcedure()
			end
			aux.RCheckAdditional=nil
		end
	end
end