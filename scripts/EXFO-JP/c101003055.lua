--オイラーサーキット
--Euler Circuit
--Scripted by Eerie Code
function c101003055.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c101003055.atkcon)
	c:RegisterEffect(e2)
	--give control
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c101003055.ctcon)
	e3:SetTarget(c101003055.cttg)
	e3:SetOperation(c101003055.ctop)
	c:RegisterEffect(e3)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,101003055)
	e5:SetCost(c101003055.thcost)
	e5:SetTarget(c101003055.thtg)
	e5:SetOperation(c101003055.thop)
	c:RegisterEffect(e5)
end
function c101003055.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x20b)
end
function c101003055.atkcon(e)
	return Duel.IsExistingMatchingCard(c101003055.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,3,nil)
end
function c101003055.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c101003055.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x20b) and c:IsAbleToChangeControler()
end
function c101003055.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101003055.ctfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101003055.ctfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c101003055.ctfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c101003055.ctop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsControler(tp) then
		Duel.GetControl(tc,1-tp)
	end
end
function c101003055.cfilter(c)
	return c:IsSetCard(0x20b) and c:IsDiscardable()
end
function c101003055.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c101003055.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.DiscardHand(tp,c101003055.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c101003055.filter(c)
	return c:IsCode(101003055) and c:IsAbleToHand()
end
function c101003055.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101003055.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101003055.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstMatchingCard(c101003055.filter,tp,LOCATION_DECK,0,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
