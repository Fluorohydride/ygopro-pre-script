--トリックスター・シャクナージュ
--Trickstar Shakhnaj
function c101004008.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101004008,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,101004008)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c101004008.spcost)
	e1:SetTarget(c101004008.sptg)
	e1:SetOperation(c101004008.spop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101004008,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101004008.damcon)
	e2:SetOperation(c101004008.damop)
	c:RegisterEffect(e2)
end
function c101004008.cfilter(c)
	return c:IsSetCard(0xfb) and c:IsDiscardable()
end
function c101004008.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101004008.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c101004008.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c101004008.filter(c,e,tp)
	return c:IsSetCard(0xfb) and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c101004008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101004008.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101004008.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101004008.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101004008.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101004008.damfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_GRAVE) and not c:IsControler(tp)
end
function c101004008.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101004008.damfilter,1,nil,tp)
end
function c101004008.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,101004008)
	local ct=eg:FilterCount(c101004008.damfilter,nil,tp)
	Duel.Damage(1-tp,ct*200,REASON_EFFECT)
end
