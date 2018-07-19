--魔妖廻天
-- Mayakashi Kaiten
function c100410038.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100410038+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100410038.target)
	e1:SetOperation(c100410038.activate)
	c:RegisterEffect(e1)
end
function c100410038.filter(c)
	return c:IsSetCard(0x227) and not c:IsCode(100410038) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c100410038.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100410038.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c100410038.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100410038.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectYesNo(tp,aux.Stringid(100410038,0))) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
