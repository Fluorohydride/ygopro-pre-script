--究極進化薬
--Ultra Evolution
--Scripted by dest
function c100217032.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100217032+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c100217032.cost)
	e1:SetTarget(c100217032.target)
	e1:SetOperation(c100217032.activate)
	c:RegisterEffect(e1)
end
function c100217032.costfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_DINOSAUR) and c:IsAbleToRemoveAsCost()
end
function c100217032.costfilter2(c)
	return c:IsType(TYPE_MONSTER) and not c:IsRace(RACE_DINOSAUR) and c:IsAbleToRemoveAsCost()
end
function c100217032.filter(c,e,tp)
	return c:IsRace(RACE_DINOSAUR) and c:IsLevelAbove(7) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c100217032.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c100217032.filter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp)
	local tc=nil
	if g:GetCount()==1 and g:GetFirst():IsLocation(LOCATION_HAND) then tc=g:GetFirst() end
	if chk==0 then return Duel.IsExistingMatchingCard(c100217032.costfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,tc)
		and Duel.IsExistingMatchingCard(c100217032.costfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,tc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c100217032.costfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,tc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c100217032.costfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,tc)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c100217032.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100217032.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c100217032.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100217032.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
