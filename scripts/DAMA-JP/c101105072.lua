--繋がれし魔鍵
--
--scripted by zerovoros a.k.a faultzone
function c101105072.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_FUSION_SUMMON+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c101105072.thtg)
	c:RegisterEffect(e1)
end
function c101105072.thfilter(c,e,tp)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and (c:IsType(TYPE_NORMAL) or c:IsSetCard(0x266))
end
function c101105072.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101105072.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101105072.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	e:SetCategory(CATEGORY_TOHAND)
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e:SetOperation(c101105072.thop)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101105072.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101105072.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		local fus=c101105072.fustg(e,tp,eg,ep,ev,re,r,rp,0)
		local rit=c101105072.rittg(e,tp,eg,ep,ev,re,r,rp,0)
		if fus or rit then
			local opt=0
			if fus and rit then
				opt=Duel.SelectOption(tp,aux.Stringid(101105072,0),aux.Stringid(101105072,1))
			elseif fus then
				opt=Duel.SelectOption(tp,aux.Stringid(101105072,0))
			else
				opt=Duel.SelectOption(tp,aux.Stringid(101105072,1))
			end
			if opt==0 then
				c101105072.fusop(e,tp,eg,ep,ev,re,r,rp)
			else
				c101105072.ritop(e,tp,eg,ep,ev,re,r,rp)
			end
		end
	end
end
function c101105072.fusfilter1(c,e,tp,m,f,chkf)
	return not c:IsImmuneToEffect(e)
end
function c101105072.fusfilter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x266) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c101105072.fustg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local res=Duel.IsExistingMatchingCard(c101105072.fusfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c101105072.fusfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101105072.fusop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c101105072.fusfilter1,nil,e)
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
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP_DEFENSE)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function c101105072.ritfilter(c,e,tp,m)
	if bit.band(c:GetType(),0x81)~=0x81 or not c:IsSetCard(0x266)
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	if c.mat_filter then
		m=m:Filter(c.mat_filter,nil,tp)
	end
	return m:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
end
function c101105072.matfilter(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function c101105072.rittg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c101105072.matfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(c101105072.ritfilter,tp,LOCATION_HAND,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c101105072.ritop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mg=Duel.GetMatchingGroup(c101105072.matfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c101105072.ritfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil,tp)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
		tc:SetMaterial(mat)
		Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
