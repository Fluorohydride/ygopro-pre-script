--Ai-コンタクト

--Scripted by mallu11
function c101012056.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101012056,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101012056+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101012056.condition)
	e1:SetCost(c101012056.cost)
	e1:SetTarget(c101012056.target)
	e1:SetOperation(c101012056.activate)
	c:RegisterEffect(e1)
end
function c101012056.cfilter(c)
	return c:IsCode(59054773) and not c:IsPublic() and c:IsAbleToDeck()
end
function c101012056.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(59054773,tp,LOCATION_FZONE)
end
function c101012056.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c101012056.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c101012056.cfilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp,3)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c101012056.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
end
function c101012056.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK) then
		Duel.Draw(tp,3,REASON_EFFECT)
	end
end
