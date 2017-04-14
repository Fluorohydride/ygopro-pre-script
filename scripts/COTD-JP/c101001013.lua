--ジャック・ワイバーン
--Jack Wyvern
--Script by nekrozar
function c101001013.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101001013,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101001013)
	e1:SetCost(c101001013.spcost)
	e1:SetTarget(c101001013.sptg)
	e1:SetOperation(c101001013.spop)
	c:RegisterEffect(e1)
end
function c101001013.costfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsAbleToRemoveAsCost()
end
function c101001013.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c101001013.costfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,c101001013.costfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	rg:AddCard(e:GetHandler())
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function c101001013.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101001013.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101001013.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101001013.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101001013.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101001013.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
