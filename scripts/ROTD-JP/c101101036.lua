--メガリス・フール

--Scripted by mallu11
function c101101036.initial_effect(c)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101101036,0))
	e1:SetCategory(CATEGORY_LVCHANGE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101101036)
	e1:SetCondition(c101101036.thcon)
	e1:SetTarget(c101101036.thtg)
	e1:SetOperation(c101101036.thop)
	c:RegisterEffect(e1)
	--ritual summon
	local e2=aux.AddRitualProcGreater2(c,c101101036.filter,LOCATION_HAND+LOCATION_DECK)
	e2:SetDescription(aux.Stringid(101101036,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,101101136)
	e2:SetCondition(c101101036.rscon)
end
function c101101036.thfilter(c,lv)
	return c:IsType(TYPE_RITUAL) and not c:IsLevel(lv) and c:IsAbleToHand()
end
function c101101036.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c101101036.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local lv=c:GetLevel()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101101036.thfilter(chkc,lv) end
	if chk==0 then return c:IsLevelAbove(1) and c:IsRelateToEffect(e)
		and Duel.IsExistingTarget(c101101036.thfilter,tp,LOCATION_GRAVE,0,1,nil,lv) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101101036.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,lv)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101101036.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local lv=tc:GetLevel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		Duel.BreakEffect()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c101101036.filter(c,e,tp,chk)
	return c:IsSetCard(0x138)
end
function c101101036.rscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
