--サイバネット・フュージョン
--Cynet Fusion
--Script by dest
function c101006050.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101006050.target)
	e1:SetOperation(c101006050.activate)
	c:RegisterEffect(e1)
end
function c101006050.cfilter(c)
	return c:GetSequence()>=5
end
function c101006050.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c101006050.filter2(c,e,tp,m,f,chkf,exmg)
	local res=nil
	if exmg~=nil then
		for gc in aux.Next(exmg) do
			m:AddCard(gc)
			if c:CheckFusionMaterial(m,gc,chkf) then res=true end
			m:RemoveCard(gc)
		end
	end
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_CYBERSE) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and (c:CheckFusionMaterial(m,nil,chkf) or res)
end
function c101006050.filter3(c)
	return c:IsType(TYPE_LINK) and c:IsRace(RACE_CYBERSE) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c101006050.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local exmg=nil
		if not Duel.IsExistingMatchingCard(c101006050.cfilter,tp,LOCATION_MZONE,0,1,nil) then
			exmg=Duel.GetMatchingGroup(c101006050.filter3,tp,LOCATION_GRAVE,0,nil)
		end
		local res=Duel.IsExistingMatchingCard(c101006050.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf,exmg)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c101006050.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf,exmg)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101006050.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c101006050.filter1,nil,e)
	local exmg=nil
	if not Duel.IsExistingMatchingCard(c101006050.cfilter,tp,LOCATION_MZONE,0,1,nil) then
		exmg=Duel.GetMatchingGroup(c101006050.filter3,tp,LOCATION_GRAVE,0,nil)
	end
	local sg1=Duel.GetMatchingGroup(c101006050.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf,exmg)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c101006050.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf,exmg)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if exmg~=nil then exmg=exmg:Filter(Card.IsCanBeFusionMaterial,nil,tc) end
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=nil
			if exmg~=nil and (not tc:CheckFusionMaterial(mg1,nil,chkf) or Duel.SelectYesNo(tp,aux.Stringid(101006050,0))) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local gc=exmg:Select(tp,1,1,nil):GetFirst()
				mat1=Duel.SelectFusionMaterial(tp,tc,mg1,gc,chkf)
			else
				mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			end
			tc:SetMaterial(mat1)
			local rg=mat1:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
			mat1:Sub(rg)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
