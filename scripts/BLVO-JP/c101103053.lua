--武装竜の震霆

--Scripted by mallu11
function c101103053.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101103053,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,101103053)
	e1:SetTarget(c101103053.target)
	e1:SetOperation(c101103053.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(101103053,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetTarget(c101103053.thtg)
	e2:SetOperation(c101103053.thop)
	c:RegisterEffect(e2)
	--replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c101103053.reptg)
	e3:SetOperation(c101103053.repop)
	e3:SetValue(c101103053.repval)
	c:RegisterEffect(e3)
end
function c101103053.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x111) and c:IsLevelAbove(1)
end
function c101103053.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101103053.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101103053.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101103053.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c101103053.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(tc:GetLevel()*100)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c101103053.tgfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x111) and c:IsLevelAbove(1) and Duel.IsExistingMatchingCard(c101103053.thfilter,tp,LOCATION_GRAVE,0,1,nil,c:GetLevel())
end
function c101103053.thfilter(c,lv)
	return c:IsSetCard(0x111) and c:IsLevelBelow(lv) and c:IsAbleToHand()
end
function c101103053.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101103053.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101103053.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101103053.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c101103053.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101103053.thfilter),tp,LOCATION_GRAVE,0,1,1,nil,tc:GetLevel())
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c101103053.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x111) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c101103053.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsStatus(STATUS_DESTROY_CONFIRMED)
		and c:IsAbleToGrave() and eg:IsExists(c101103053.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c101103053.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
function c101103053.repval(e,c)
	return c101103053.repfilter(c,e:GetHandlerPlayer())
end
