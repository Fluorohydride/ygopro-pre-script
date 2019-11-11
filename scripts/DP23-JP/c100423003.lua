--魂のしもべ

--Scripted by mallu11
function c100423003.initial_effect(c)
	aux.AddCodeList(c,46986414,38033121)
	--set top
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100423003,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100423003.target)
	e1:SetOperation(c100423003.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100423003,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100423003)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c100423003.drtg)
	e2:SetOperation(c100423003.drop)
	c:RegisterEffect(e2)
end
function c100423003.filter(c)
	return (aux.IsCodeListed(c,46986414) or aux.IsCodeListed(c,38033121) or c:IsCode(46986414)) and not c:IsCode(100423003)
		and (c:IsAbleToDeck() or c:IsLocation(LOCATION_DECK))
end
function c100423003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100423003.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c100423003.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100423003,2))
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100423003.filter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsLocation(LOCATION_DECK) then
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(tc,0)
		else
			Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
		end
		if tc:IsLocation(LOCATION_DECK) then
			Duel.ConfirmDecktop(tp,1)
		end
	end
end
function c100423003.cfilter(c)
	return (c:IsCode(46986414,38033121) or (c:IsSetCard(0x23a) and c:IsType(TYPE_MONSTER))) and c:IsFaceup()
end
function c100423003.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c100423003.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	local ct=g:GetClassCount(Card.GetCode)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c100423003.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c100423003.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	local ct=g:GetClassCount(Card.GetCode)
	Duel.Draw(p,ct,REASON_EFFECT)
end
