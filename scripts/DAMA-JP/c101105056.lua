--ドーン・オブ・マジェスティ
--
--scripted by zerovoros a.k.a faultzone
function c101105056.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101105056.sptg)
	e1:SetOperation(c101105056.spop)
	c:RegisterEffect(e1)
end
function c101105056.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c101105056.fustg(e,tp,eg,ep,ev,re,r,rp,chk) or c101105056.rittg(e,tp,eg,ep,ev,re,r,rp,chk) end
end
function c101105056.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local fus=c101105056.fustg(e,tp,eg,ep,ev,re,r,rp,0)
	local rit=c101105056.rittg(e,tp,eg,ep,ev,re,r,rp,0)
	if fus or rit then
		local opt=0
		if fus and rit then
			opt=Duel.SelectOption(tp,aux.Stringid(101105056,0),aux.Stringid(101105056,1))
		elseif fus then
			opt=Duel.SelectOption(tp,aux.Stringid(101105056,0))
		else
			opt=Duel.SelectOption(tp,aux.Stringid(101105056,1))
		end
		if opt==0 then
			c101105056.fusop(e,tp,eg,ep,ev,re,r,rp)
		else
			aux.AddRitualProcGreater2(c,c101105056.ritfilter)
			-- c101105056.ritop(e,tp,eg,ep,ev,re,r,rp)
		end
	end
end
function c101105056.cfilter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_NORMAL)
end
function c101105056.fusfilter1(c,e,tp,m,f,chkf)
	return not c:IsImmuneToEffect(e)
end
function c101105056.fusfilter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x266) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c101105056.exfilter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_NORMAL) and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c101105056.fustg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsAbleToGrave,nil)
		if Duel.IsExistingMatchingCard(c101105056.cfilter,tp,LOCATION_MZONE,0,1,nil) then
			local sg=Duel.GetMatchingGroup(c101105056.exfilter,tp,LOCATION_DECK,0,nil,e)
			if sg:GetCount()>0 then
				mg1:Merge(sg)
			end
		end
		local res=Duel.IsExistingMatchingCard(c101105056.fusfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c101105056.fusfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101105056.fusop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c101105056.fusfilter1,nil,e)
	local exmat=false
	if Duel.IsExistingMatchingCard(c101105056.cfilter,tp,LOCATION_MZONE,0,1,nil) then
		local sg=Duel.GetMatchingGroup(c101105056.exfilter,tp,LOCATION_DECK,0,nil,e)
		if sg:GetCount()>0 then
			mg1:Merge(sg)
			exmat=true
		end
	end
	local sg1=Duel.GetMatchingGroup(c101105056.fusfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	aux.FCheckAdditional=nil
	aux.GCheckAdditional=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c101105056.fusfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
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
function c101105056.ritfilter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0x266)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c101105056.rittg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		return Duel.IsExistingMatchingCard(c101105056.ritfilter,tp,LOCATION_HAND,0,1,nil,e,tp,mg1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c101105056.ritop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c101105056.ritfilter,tp,LOCATION_HAND,0,1,1,nil,nil,e,tp,mg,nil,Card.GetOriginalLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:RemoveCard(tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local lv=Card.GetOriginalLevel(tc)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,lv,"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,lv,tp,tc,lv,"Greater")
		aux.GCheckAdditional=nil
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
