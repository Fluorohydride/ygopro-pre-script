--背徳の堕天使
--Darklords Falling from Grace
--Script by nekrozar
function c100405036.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100405036+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c100405036.cost)
	e1:SetTarget(c100405036.target)
	e1:SetOperation(c100405036.activate)
	c:RegisterEffect(e1)
end
function c100405036.costfilter(c)
	return c:IsSetCard(0xef)
		and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function c100405036.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100405036.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100405036.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c100405036.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local exc=nil
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then exc=e:GetHandler() end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,exc)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100405036.activate(e,tp,eg,ep,ev,re,r,rp)
	local exc=nil
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then exc=e:GetHandler() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,exc)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
