--閃刀術式－ベクタードブラスト
--Sky Striker Maneuver - Vectored Blast!
--Script by dest
function c101006061.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101006061.condition)
	e1:SetTarget(c101006061.target)
	e1:SetOperation(c101006061.operation)
	c:RegisterEffect(e1)
end
function c101006061.cfilter(c)
	return c:GetSequence()<5
end
function c101006061.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c101006061.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101006061.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,2) and Duel.IsPlayerCanDiscardDeck(1-tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,0,0,PLAYER_ALL,2)
	if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3 then
		e:SetCategory(CATEGORY_DECKDES+CATEGORY_TOEXTRA)
	end
end
function c101006061.filter(c,tp)
	return c:GetSequence()>=5 and c:IsControler(1-tp) and c:IsAbleToDeck()
end
function c101006061.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetDecktopGroup(tp,2)
	local g2=Duel.GetDecktopGroup(1-tp,2)
	g1:Merge(g2)
	if Duel.SendtoGrave(g1,REASON_EFFECT)~=0
		and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3
		and Duel.IsExistingMatchingCard(c101006061.filter,tp,0,LOCATION_MZONE,1,nil,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(101006061,0)) then
		local g=Duel.GetMatchingGroup(c101006061.filter,tp,0,LOCATION_MZONE,nil,tp)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
