--Chaos Space
function c100268009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100268009)
	e1:SetCost(c100268009.cost)
	e1:SetTarget(c100268009.target)
	e1:SetOperation(c100268009.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100268009+100)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c100268009.drtg)
	e2:SetOperation(c100268009.drop)
	c:RegisterEffect(e2)
end
function c100268009.cfilter2(c,tc)
	return c:IsType(TYPE_MONSTER)
		and not c:IsAttribute(tc:GetAttribute())
		and not c:IsSummonableCard()
		and c:IsLevelAbove(4)
		and c:IsLevelBelow(8)
end
function c100268009.cfilter(c)
	local tp=c:GetControler()
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_LIGHT)
		and c:IsDiscardable()
		and Duel.IsExistingMatchingCard(c100268009.cfilter2,tp,LOCATION_DECK,0,1,nil,c)
end
function c100268009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100268009.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local c=Duel.SelectMatchingCard(tp,c100268009.cfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	e:SetLabelObject(c)
end
function c100268009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100268009.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100268009.cfilter2,tp,LOCATION_DECK,0,1,1,nil,tc)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c100268009.drfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_LIGHT)
		and not c:IsSummonableCard()
		and c:IsAbleToDeck()
end
function c100268009.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp)
		and c100268009.drfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c100268009.drfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c100268009.drfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c100268009.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=1 then return end
	Duel.SendtoDeck(tg,nil,1,REASON_EFFECT)
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==1 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
