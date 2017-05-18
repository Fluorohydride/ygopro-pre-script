--ボンディング-DHO
--Bonding - DHO
--Scripted by Eerie Code
function c100418039.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c100418039.cost)
	e1:SetTarget(c100418039.target)
	e1:SetOperation(c100418039.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c100418039.thcost)
	e2:SetTarget(c100418039.thtg)
	e2:SetOperation(c100418039.thop)
	c:RegisterEffect(e2)
end
function c100418039.cfilter(c,code)
	return c:IsCode(code) and c:IsAbleToDeckAsCost()
end
function c100418039.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100418039.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,100418037)
		and Duel.IsExistingMatchingCard(c100418039.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,22587018)
		and Duel.IsExistingMatchingCard(c100418039.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,58071123) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,c100418039.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,100418037)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectMatchingCard(tp,c100418039.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,22587018)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g3=Duel.SelectMatchingCard(tp,c100418039.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,58071123)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.ConfirmCards(1-tp,g1)
	Duel.SendtoDeck(g1,nil,2,REASON_COST)
end
function c100418039.filter(c,e,tp)
	return c:IsCode(100418036) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c100418039.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100418039.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c100418039.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100418039.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end
function c100418039.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c100418039.thfilter(c)
	return c:IsCode(100418036,85066822) and c:IsAbleToHand()
end
function c100418039.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100418039.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c100418039.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100418039.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
