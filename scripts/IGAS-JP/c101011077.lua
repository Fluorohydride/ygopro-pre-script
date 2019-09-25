--アームズ・コール

--Scripted by nekrozar
function c101011077.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101011077+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101011077.target)
	e1:SetOperation(c101011077.activate)
	c:RegisterEffect(e1)
end
function c101011077.filter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c101011077.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101011077.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101011077.eqfilter(c,tc)
	return c:IsFaceup() and tc:CheckEquipTarget(c)
end
function c101011077.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c101011077.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g1:GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g1)
		local g2=Duel.GetMatchingGroup(c101011077.eqfilter,tp,LOCATION_MZONE,0,nil,tc)
		if tc:CheckUniqueOnField(tp) and not tc:IsForbidden() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101011077,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local sg=g2:Select(tp,1,1,nil)
			Duel.Equip(tp,tc,sg:GetFirst())
		end
	end
end
