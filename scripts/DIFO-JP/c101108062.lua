--ゲネラールプローベ
--
--Script by Trishula9
function c101108062.initial_effect(c)
	c:EnableCounterPermit(0x35)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c101108062.ctcon)
	e2:SetOperation(c101108062.ctop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,101108062)
	e3:SetCost(c101108062.thcost)
	e3:SetTarget(c101108062.thtg)
	e3:SetOperation(c101108062.thop)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,101108062+100)
	e4:SetCondition(c101108062.thcon2)
	e4:SetTarget(c101108062.thtg2)
	e4:SetOperation(c101108062.thop2)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function c101108062.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x1066) and not re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c101108062.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x35,1)
end
function c101108062.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x35,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x35,3,REASON_COST)
end
function c101108062.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1066) and c:IsAbleToHand()
end
function c101108062.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c101108062.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101108062.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101108062.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101108062.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x1066) and c:IsSummonPlayer(tp)
end
function c101108062.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101108062.cfilter,1,nil,tp)
end
function c101108062.thfilter2(c)
	return c:IsCode(75304793) and c:IsAbleToHand()
end
function c101108062.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101108062.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101108062.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101108062.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end