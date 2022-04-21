--壱世壊に軋む爪音
--
--Script by JoyJ
function c101109071.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101109071)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c101109071.condition)
	e1:SetTarget(c101109071.target)
	e1:SetOperation(c101109071.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,101109071)
	e2:SetCondition(c101109071.thcon)
	e2:SetTarget(c101109071.thtg)
	e2:SetOperation(c101109071.thop)
	c:RegisterEffect(e2)
end
function c101109071.actcfilter(c)
	return ((c:IsSetCard(0x284) and c:IsLocation(LOCATION_MZONE)) or c:IsCode(56099748)) and c:IsFaceup()
end
function c101109071.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101109071.actcfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c101109071.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c101109071.tgfilter(c)
	return c:IsSetCard(0x284) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function c101109071.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c101109071.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101109071.posfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c101109071.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c101109071.posfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c101109071.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c101109071.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.BreakEffect()
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function c101109071.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c101109071.thfilter(c)
	return c:IsSetCard(0x284) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c101109071.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101109071.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101109071.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101109071.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101109071.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
