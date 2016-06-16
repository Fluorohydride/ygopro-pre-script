--化合獣カーボン・クラブ
--Chemical Beast Carbon Crab
--Script by dest
function c100910024.initial_effect(c)
	aux.EnableDualAttribute(c)
	--to grave/search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100910024,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,100910024)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(aux.IsDualState)
	e1:SetTarget(c100910024.tgtg)
	e1:SetOperation(c100910024.tgop)
	c:RegisterEffect(e1)
end
function c100910024.filter(c)
	return c:IsType(TYPE_DUAL) and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(c100910024.thfilter,tp,LOCATION_DECK,0,1,c)
end
function c100910024.tgfilter(c)
	return c:IsType(TYPE_DUAL) and c:IsAbleToGrave()
end
function c100910024.thfilter(c)
	return c:IsType(TYPE_DUAL) and c:IsAbleToHand()
end
function c100910024.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100910024.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100910024.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100910024.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		if not g:GetFirst():IsLocation(LOCATION_GRAVE)
			or not Duel.IsExistingMatchingCard(c100910024.thfilter,tp,LOCATION_DECK,0,1,nil) then return end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,c100910024.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if tg:GetCount()>0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
