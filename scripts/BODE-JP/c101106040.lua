--Ursatron, the Celestial Polar Illuminaship
--scripted by XyLeN
function c101106040.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon restriction
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--to hand (deck)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101106040,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c101106040.thcon)
	e1:SetTarget(c101106040.thtg1)
	e1:SetOperation(c101106040.thop1)
	c:RegisterEffect(e1)
	--to hand (remove) 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101106040,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c101106040.thtg2)
	e2:SetOperation(c101106040.thop2)
	c:RegisterEffect(e2)
end
function c101106040.cfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsSummonPlayer(tp)
end
function c101106040.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c101106040.cfilter,1,nil,tp)
end
function c101106040.thfilter1(c)
	return c:IsSetCard(0x163,0x154) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c101106040.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101106040.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101106040.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101106040.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101106040.thfilter2(c)
	return c101106040.thfilter1(c) and c:IsFaceup()
end
function c101106040.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101106040.thfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101106040.thfilter2,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101106040.thfilter2,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101106040.thop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
