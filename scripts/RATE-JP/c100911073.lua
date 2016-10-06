--天地開闢
--Universal Beginning
--Script by nekrozar
function c100911073.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100911073+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100911073.target)
	e1:SetOperation(c100911073.activate)
	c:RegisterEffect(e1)
end
function c100911073.filter1(c)
	return c:IsRace(RACE_WARRIOR) and c:IsAbleToHand()
end
function c100911073.filter2(c)
	return c:IsSetCard(0x10cf) or c:IsSetCard(0xbd)
end
function c100911073.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c100911073.filter1,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:GetCount()>2 and g:IsExists(c100911073.filter2,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c100911073.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100911073.filter1,tp,LOCATION_DECK,0,nil)
	if g:IsExists(c100911073.filter2,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g:Select(tp,1,1,nil)
		g:RemoveCard(sg1:GetFirst())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g:Select(tp,2,2,nil)
		sg2:Merge(sg1)
		Duel.ConfirmCards(1-tp,sg1)
		Duel.ShuffleDeck(tp)
		local tg=sg1:RandomSelect(1-tp,1)
		local tc=tg:GetFirst()
		if c100911073.filter2(tc) and tc:IsAbleToHand() then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			sg1:RemoveCard(tc)
		end
		Duel.SendtoGrave(sg1,REASON_EFFECT)
	end
end
