--魂の開封

--Script by nekrozar
function c100237002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c100237002.condition)
	e1:SetTarget(c100237002.target)
	e1:SetOperation(c100237002.activate)
	c:RegisterEffect(e1)
end
function c100237002.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
end
function c100237002.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100237002.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100237002.filter(c)
	return c:IsType(TYPE_NORMAL) and c:IsAbleToHand()
end
function c100237002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,30459350)
		and Duel.IsExistingMatchingCard(c100237002.filter,tp,LOCATION_DECK,0,5,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100237002.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,30459350) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100237002,0))
	local g=Duel.SelectMatchingCard(tp,c100237002.filter,tp,LOCATION_DECK,0,5,5,nil)
	if g:GetCount()<5 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	g:Sub(sg)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
