--タイム・ストリーム
--
--Script by mercury233
function c100266012.initial_effect(c)
	aux.AddCodeList(c,100266011)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100266012,0))
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100266012.target)
	e1:SetOperation(c100266012.activate)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100266012,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c100266012.spcost)
	e2:SetTarget(c100266012.sptg)
	e2:SetOperation(c100266012.spop)
	c:RegisterEffect(e2)
end
function c100266012.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x248) and c:IsType(TYPE_FUSION) and c:IsReleasableByEffect()
		and Duel.IsExistingMatchingCard(c100266012.ffilter,tp,LOCATION_EXTRA,0,1,nil,c:GetOriginalLevel(),e,tp,c)
end
function c100266012.ffilter(c,lv,e,tp,tc)
	return c:IsSetCard(0x248) and c:IsType(TYPE_FUSION) and c:GetOriginalLevel()==lv+2
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION+0x20,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
end
function c100266012.chkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x248) and c:IsType(TYPE_FUSION)
end
function c100266012.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsReleasableByEffect()
		and chkc:IsFaceup() and chkc:IsSetCard(0x248) and chkc:IsType(TYPE_FUSION) end
	if chk==0 then return Duel.IsExistingTarget(c100266012.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTarget(tp,c100266012.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
end
function c100266012.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local lv=tc:GetOriginalLevel()
	if Duel.Release(tc,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c100266012.ffilter,tp,LOCATION_EXTRA,0,1,1,nil,lv,e,tp,nil)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SpecialSummon(sg,SUMMON_TYPE_FUSION+0x20,tp,tp,false,false,POS_FACEUP)
		sg:GetFirst():CompleteProcedure()
	end
end
function c100266012.cfilter(c,e,tp)
	return c:IsSetCard(0x248) and c:IsType(TYPE_FUSION) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingTarget(c100266012.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp)
end
function c100266012.spfilter(c,e,tp)
	return c:IsSetCard(0x248) and c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100266012.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c100266012.cfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c100266012.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c100266012.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c100266012.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c100266012.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100266012.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
