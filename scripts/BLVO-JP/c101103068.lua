--スプリガンズ・コール！

--Scripted by mallu11
function c101103068.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101103068,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,101103068)
	e1:SetTarget(c101103068.sptg)
	e1:SetOperation(c101103068.spop)
	c:RegisterEffect(e1)
	--overlay
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101103068,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,101103168)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c101103068.ovcost)
	e2:SetTarget(c101103068.ovtg)
	e2:SetOperation(c101103068.ovop)
	c:RegisterEffect(e2)
end
function c101103068.spfilter(c,e,tp)
	return (c:IsSetCard(0x257) and c:IsType(TYPE_MONSTER) or c:IsCode(68468459)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101103068.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101103068.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c101103068.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101103068.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101103068.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101103068.costfilter(c)
	return c:IsType(TYPE_FUSION) and c:IsAbleToRemoveAsCost()
end
function c101103068.ovcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c101103068.costfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101103068.costfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101103068.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x257) and c:IsType(TYPE_XYZ)
end
function c101103068.ovfilter(c,e)
	return c:IsType(TYPE_FUSION) and aux.IsMaterialListCode(c,68468459) and c:IsCanOverlay() and (not e or not c:IsImmuneToEffect(e))
end
function c101103068.ovtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101103068.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101103068.tgfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c101103068.ovfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101103068.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101103068.ovop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c101103068.ovfilter,tp,LOCATION_EXTRA,0,1,1,nil,e)
		local oc=g:GetFirst()
		if oc then
			Duel.Overlay(tc,oc)
		end
	end
end
