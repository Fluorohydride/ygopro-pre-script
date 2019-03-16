--天威龍－アーダラ
--
--scripted by JoyJ
function c101009012.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101009012,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101009012)
	e1:SetCondition(c101009012.spcon)
	e1:SetTarget(c101009012.sptg)
	e1:SetOperation(c101009012.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101009012,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,101009012+100)
	e2:SetCondition(c101009012.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101009012.thtg)
	e2:SetOperation(c101009012.thop)
	c:RegisterEffect(e2)
end
function c101009012.spcfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup()
end
function c101009012.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c101009012.spcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101009012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101009012.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101009012.thcfilter(c)
	return not c:IsType(TYPE_EFFECT) and c:IsFaceup()
end
function c101009012.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101009012.thcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101009012.thfilter(c)
	return c:IsRace(RACE_WYRM) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsFaceup()
end
function c101009012.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c101009012.thfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c101009012.thfilter,tp,LOCATION_REMOVED,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101009012.thfilter,tp,LOCATION_REMOVED,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101009012.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
