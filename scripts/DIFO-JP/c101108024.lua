--戦華の暴－董穎

--Script by Chrono-Genex
function c101108024.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101108024,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,101108024)
	e1:SetTarget(c101108024.thtg)
	e1:SetOperation(c101108024.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--activate cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_ACTIVATE_COST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c101108024.costcon)
	e2:SetCost(c101108024.costchk)
	e2:SetOperation(c101108024.costop)
	c:RegisterEffect(e2)
	--accumulate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(0x10000000+101108024)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c101108024.costcon)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101108024,1))
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,101108024+100)
	e4:SetCondition(c101108024.rmcon)
	e4:SetTarget(c101108024.rmtg)
	e4:SetOperation(c101108024.rmop)
	c:RegisterEffect(e4)
end
function c101108024.thfilter(c)
	return c:IsSetCard(0x137) and ((c:IsLevelAbove(7) and c:IsType(TYPE_MONSTER)) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS))) and c:IsAbleToHand()
end
function c101108024.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101108024.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101108024.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101108024.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101108024.costcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x137) and c:IsLevelAbove(7)
end
function c101108024.costcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c101108024.costcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101108024.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffect(tp,101108024)
	return Duel.CheckLPCost(tp,ct*400)
end
function c101108024.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.PayLPCost(tp,400)
end
function c101108024.cfilter(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_MONSTER)
end
function c101108024.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101108024.cfilter,1,nil,1-tp)
end
function c101108024.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil)
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101108024.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
