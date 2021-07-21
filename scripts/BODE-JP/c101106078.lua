--聖邪のステンドグラス
--
--Script by 魔方
function c101106078.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101106078)
	e1:SetTarget(c101106078.target)
	e1:SetOperation(c101106078.activate)
	c:RegisterEffect(e1)
end
function c101106078.filter(c,race)
	return c:IsRace(race) and c:IsType(TYPE_EFFECT) and c:IsFaceup()
end
function c101106078.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local f1=Duel.IsExistingMatchingCard(c101106078.filter,tp,LOCATION_MZONE,0,1,nil,RACE_FAIRY) and Duel.IsPlayerCanDraw(tp,3)
	local f2=Duel.IsExistingMatchingCard(c101106078.filter,tp,LOCATION_MZONE,0,1,nil,RACE_FIEND) and Duel.IsPlayerCanDraw(1-tp,1)
	if chk==0 then return f1 or f2 end
	if f1 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,2)
	end
	if f2 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,1)
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
	end
end
function c101106078.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c101106078.filter,tp,LOCATION_MZONE,0,1,nil,RACE_FAIRY) and Duel.Draw(tp,3,REASON_EFFECT)==3 then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
		if g:GetCount()==0 then return end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local sg=g:Select(tp,2,2,nil)
		Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
		Duel.SortDecktop(tp,tp,2)
		for i=1,2 do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),1)
		end
	end
	if Duel.IsExistingMatchingCard(c101106078.filter,tp,LOCATION_MZONE,0,1,nil,RACE_FIEND) and Duel.Draw(1-tp,1,REASON_EFFECT)==1 then
		Duel.ShuffleHand(1-tp)
		Duel.BreakEffect()
		Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
		local g1=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_HAND,nil)
		if #g1==0 then return end
		Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end