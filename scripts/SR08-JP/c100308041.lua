--救魔の標
--
--Script by mercury233
function c100308041.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100308041+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100308041.target)
	e1:SetOperation(c100308041.activate)
	c:RegisterEffect(e1)
end
function c100308041.filter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_EFFECT) and c:IsAbleToHand()
end
function c100308041.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c100308041.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100308041.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c100308041.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c100308041.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
