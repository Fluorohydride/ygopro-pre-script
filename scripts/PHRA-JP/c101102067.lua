--ジャック・イン・ザ・ハンド

--Scripted by mallu11
function c101102067.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101102067+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101102067.target)
	e1:SetOperation(c101102067.activate)
	c:RegisterEffect(e1)
end
function c101102067.thfilter(c)
	return c:IsLevel(1) and c:IsAbleToHand()
end
function c101102067.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c101102067.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:CheckSubGroup(aux.dncheck,3,3) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,PLAYER_ALL,LOCATION_DECK)
end
function c101102067.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101102067.thfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
	if sg and #sg==3 then
		Duel.ConfirmCards(1-tp,sg)
		local oc=sg:Select(1-tp,1,1,nil):GetFirst()
		if Duel.SendtoHand(oc,1-tp,REASON_EFFECT)~=0 and oc:IsLocation(LOCATION_HAND) then
			sg:RemoveCard(oc)
			local sc=sg:Select(tp,1,1,nil):GetFirst()
			Duel.SendtoHand(sc,tp,REASON_EFFECT)
		end
	end
end
