--エクソシスター・アーメント
--
--Scripted by KillerDJ
function c100417022.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,100417022+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c100417022.cost)
	e1:SetCondition(c100417022.condition)
	e1:SetTarget(c100417022.target)
	e1:SetOperation(c100417022.activate)
	c:RegisterEffect(e1)
end
function c100417022.checkfilter(c)
	return c:IsFaceup() and c:IsSummonLocation(LOCATION_GRAVE)
end
function c100417022.condition(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c100417022.checkfilter,tp,0,LOCATION_MZONE,1,nil) then return true end
	return Duel.GetTurnPlayer()~=tp
end
function c100417022.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c100417022.cfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c100417022.spfilter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x271)
		and Duel.IsExistingMatchingCard(c100417022.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c100417022.spfilter2(c,e,tp,mc)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x271) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
		and not Duel.IsExistingMatchingCard(c100417022.cfilter,tp,LOCATION_ONFIELD,0,1,nil,c:GetCode())
end
function c100417022.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c100417022.spfilter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c100417022.spfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c100417022.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100417022.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100417022.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
