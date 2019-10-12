--執愛のウヴァループ

--Scripted by mallu11
function c101011028.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101011028,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101011028)
	e1:SetTarget(c101011028.sptg)
	e1:SetOperation(c101011028.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101011028,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101011128)
	e2:SetTarget(c101011028.thtg)
	e2:SetOperation(c101011028.thop)
	c:RegisterEffect(e2)
end
function c101011028.spfilter(c,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsAbleToRemove() and Duel.GetMZoneCount(tp,c)>0 and c:IsFaceup()
end
function c101011028.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and chkc:IsControler(tp) and c101011028.spfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101011028.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c101011028.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101011028.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101011028.thfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsAbleToRemove() and c:IsFaceup()
end
function c101011028.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and chkc:IsControler(tp) and c101011028.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101011028.thfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,c) and c:IsAbleToHand() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c101011028.thfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c101011028.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
