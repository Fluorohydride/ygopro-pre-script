--ダイナレスラー・イグアノドラッカ

--Scripted by nekrozar
function c100254008.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100254008,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100254008)
	e1:SetCost(c100254008.spcost1)
	e1:SetTarget(c100254008.sptg1)
	e1:SetOperation(c100254008.spop1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100254008,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100254108)
	e2:SetCost(c100254008.spcost2)
	e2:SetTarget(c100254008.sptg2)
	e2:SetOperation(c100254008.spop2)
	c:RegisterEffect(e2)
end
function c100254008.costfilter1(c)
	return c:IsRace(RACE_DINOSAUR) and c:IsDiscardable()
end
function c100254008.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100254008.costfilter1,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c100254008.costfilter1,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c100254008.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100254008.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100254008.costfilter2(c,e,tp)
	return c:IsRace(RACE_DINOSAUR) and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingTarget(c100254008.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function c100254008.spfilter(c,e,tp,mc)
	return c:IsSetCard(0x11a) and not c:IsOriginalCodeRule(mc:GetOriginalCodeRule()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c100254008.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c100254008.costfilter2,1,nil,e,tp) end
	local g=Duel.SelectReleaseGroup(tp,c100254008.costfilter2,1,1,nil,e,tp)
	e:SetLabelObject(g:GetFirst())
	Duel.Release(g,REASON_COST)
end
function c100254008.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mc=e:GetLabelObject()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c100254008.spfilter(chkc,e,tp,mc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c100254008.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,mc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100254008.spop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
