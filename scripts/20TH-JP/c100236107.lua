--Sin Selector
--
--Script by JoyJ
function c100236107.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100236107+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c100236107.Cost)
	e1:SetTarget(c100236107.Target)
	e1:SetOperation(c100236107.Activate)
	c:RegisterEffect(e1)
end
function c100236107.CFilter2(c)
	return c:IsSetCard(0x23) and c:IsAbleToHand() and (not c:IsCode(100236107))
end
function c100236107.RemoveCostCards(c,g)
	return g:IsExists(Card.IsCode,1,nil,c:GetCode())
end
function c100236107.Activate(e,tp,eg,ep,ev,re,r,rp)
	local costCards=e:GetLabelObject()
	local deckCards=Duel.GetMatchingGroup(c100236107.CFilter2,tp,LOCATION_DECK,0,nil)
	c100236107.Duplicated = {}
	deckCards = deckCards:Filter(c100236107.RemoveDuplicated,nil)
	deckCards:Remove(c100236107.RemoveCostCards,nil,costCards)
	if deckCards:GetCount() >= 2 then
		Duel.Hint(HINT_MESSAGE,tp,HINTMSG_ATOHAND)
		local toHand = deckCards:Select(tp,2,2,nil)
		Duel.SendtoHand(toHand,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,toHand)
	end
end
function c100236107.Target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c100236107.CFilter(c)
	return c:IsSetCard(0x23) and c:IsAbleToRemoveAsCost()
end
c100236107.Duplicated = {}
function c100236107.RemoveDuplicated(c)
	if c100236107.Duplicated[c:GetCode()] then
		return false
	end
	c100236107.Duplicated[c:GetCode()] = true
	return true
end
function c100236107.CheckSelectStep(g,c,cc)
	g:Remove(Card.IsCode,nil,c:GetCode())
	g:Remove(Card.IsCode,nil,cc:GetCode())
	return g:GetCount() >= 2
end
function c100236107.ExplodeGroup(g)
	local exploded = {}
	local index = 0
	local c = g:GetFirst()
	while c do
		exploded[index] = c
		index = index + 1
		c = g:GetNext()
	end
	return exploded
end
function c100236107.CheckSelect(g1,g2)
	local index = g1:GetCount()
	if index < 2 or g2:GetCount() < 2 then return false end --quick judge
	local c = g1:GetFirst()
	local cc = g1:GetFirst()
	local g1Explode = c100236107.ExplodeGroup(g1)
	for i = 0,(index - 2) do
		c = g1Explode[i]
		for i2 = i + 1,(index - 1) do
			cc = g1Explode[i2]
			if c100236107.CheckSelectStep(g2,c,cc) then return true end
		end
	end
	return false
end
function c100236107.Cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local graveCards=Duel.GetMatchingGroup(c100236107.CFilter,tp,LOCATION_GRAVE,0,nil,tp)
	local deckCards=Duel.GetMatchingGroup(c100236107.CFilter2,tp,LOCATION_DECK,0,nil,tp)
	
	c100236107.Duplicated = {}
	deckCards = deckCards:Filter(c100236107.RemoveDuplicated,nil)
	
	if chk==0 then return c100236107.CheckSelect(graveCards,deckCards) end
	local costCards=Duel.SelectMatchingCard(tp,c100236107.CFilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(costCards,POS_FACEUP,REASON_COST)
	costCards:KeepAlive()
	e:SetLabelObject(costCards)
end
