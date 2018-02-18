--The King of D.
--Scripted by Eerie Code
function c100241002.initial_effect(c)
	--change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(17985575)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100241002,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCost(c100241002.thcost)
	e2:SetTarget(c100241002.thtg)
	e2:SetOperation(c100241002.thop)
	c:RegisterEffect(e2)
end
function c100241002.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
end
function c100241002.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100241002.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c100241002.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c100241002.thfilter(c)
	return c:IsCode(100241004,43973174,48800175) and c:IsAbleToHand()
end
function c100241002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100241002.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100241002.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100241002.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
