--暗岩の海竜神
function c100426022.initial_effect(c)
	aux.IsCodeListed(c,22702055)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100426022+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c100426022.cost)
	e1:SetTarget(c100426022.target)
	e1:SetOperation(c100426022.activate)
	c:RegisterEffect(e1)
end
function c100426022.cfilter(c)
	return c:IsCode(22702055) and c:IsAbleToGraveAsCost() and c:IsFaceup()
end
function c100426022.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100426022.cfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100426022.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c100426022.spfilter(c,e,tp)
	return (aux.IsCodeListed(c,22702055) or (c:IsType(TYPE_NORMAL) and c:IsAttribute(ATTRIBUTE_WATER))) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c100426022.spfilter1(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100426022.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c100426022.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c100426022.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=math.min(2,(Duel.GetLocationCount(tp,LOCATION_MZONE)))
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local tg=Duel.GetMatchingGroup(c100426022.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=tg:SelectSubGroup(tp,aux.dncheck,false,1,ft)
	if g1 and #g1>0 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g2=Duel.GetMatchingGroup(c100426022.spfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	if ft1>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if ft1>0 Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(100426022,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g3=g2:Select(tp,1,ft1,nil)
		if g3 then
			Duel.SpecialSummon(g3,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end