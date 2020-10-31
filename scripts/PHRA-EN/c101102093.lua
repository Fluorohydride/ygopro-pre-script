--Myutant Fusion
function c101102093.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101102093+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101102093.target)
	e1:SetOperation(c101102093.activate)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(c101102093.regop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function c101102093.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c101102093.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c101102093.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x258) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c101102093.cfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function c101102093.fcheck(tp,sg,fc)
	return (sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1 and fc:IsLocation(LOCATION_DECK)) and (sg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<=1 and fc:IsLocation(LOCATION_GRAVE))
end
function c101102093.gcheck(sg)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1 and sg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<=1
end
function c101102093.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		if e:GetLabel()==Duel.GetTurnCount() then
			local mg2=Duel.GetMatchingGroup(c101102093.filter0,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
			if mg2:GetCount()>0 then
				mg1:Merge(mg2)
				Auxiliary.FCheckAdditional=c87931906.fcheck
				Auxiliary.GCheckAdditional=c87931906.gcheck
			end
		end
		local res=Duel.IsExistingMatchingCard(c101102093.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		Auxiliary.FCheckAdditional=nil
		Auxiliary.GCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c101102093.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101102093.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c101102093.filter1,nil,e)
	local exmat=false
	if Duel.IsExistingMatchingCard(c101102093.cfilter,tp,0,LOCATION_MZONE,1,nil) then
		local mg2=Duel.GetMatchingGroup(c101102093.filter0,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		if mg2:GetCount()>0 then
			mg1:Merge(mg2)
			exmat=true
		end
	end
	if exmat then
		Auxiliary.FCheckAdditional=c101102093.fcheck
		Auxiliary.GCheckAdditional=c101102093.gcheck
	end
	local sg1=Duel.GetMatchingGroup(c101102093.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	Auxiliary.FCheckAdditional=nil
	Auxiliary.GCheckAdditional=nil
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c101102093.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		mg1:RemoveCard(tc)
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if exmat then
				Auxiliary.FCheckAdditional=c101102093.fcheck
				Auxiliary.GCheckAdditional=c101102093.gcheck
			end
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			Auxiliary.FCheckAdditional=nil
			Auxiliary.GCheckAdditional=nil
			tc:SetMaterial(mat1)
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function c101102093.regop(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp then return end
	e:GetLabelObject():SetLabel(Duel.GetTurnCount())
end