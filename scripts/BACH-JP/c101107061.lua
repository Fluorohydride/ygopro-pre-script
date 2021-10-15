--X・Y・Zコンバイン
--
--Script by mercury233
function c101107061.initial_effect(c)
	--spsummon from deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(816427,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCountLimit(1,101107061)
	e1:SetCondition(c101107061.spcon)
	e1:SetTarget(c101107061.sptg)
	e1:SetOperation(c101107061.spop)
	c:RegisterEffect(e1)
	--spsummon from removed
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,101107061+100)
	e2:SetCost(c101107061.sprcost)
	e2:SetTarget(c101107061.sprtg)
	e2:SetOperation(c101107061.sprop)
	c:RegisterEffect(e2)
end
function c101107061.sprcfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsAbleToExtraAsCost()
end
function c101107061.sprcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101107061.sprcfilter,tp,LOCATION_MZONE,0,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	Duel.SelectMatchingCard(tp,c101107061.sprcfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101107061.sprtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c101107061.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	local max=2
	if Duel.IsPlayerAffectedByEffect(59822133) or Duel.GetMZoneCount(tp)<2 then max=1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,max,tp,LOCATION_REMOVED)
end
function c101107061.sprop(e,tp,eg,ep,ev,re,r,rp)
	local max=2
	if Duel.GetMZoneCount(tp)<1 then return end
	if Duel.IsPlayerAffectedByEffect(59822133) or Duel.GetMZoneCount(tp)<2 then max=1 end
	local g=Duel.GetMatchingGroup(c101107061.spfilter,tp,LOCATION_REMOVED,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,max)
	if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101107061.cfilter(c,tp)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT)
		and c:IsType(TYPE_UNION) and c:IsPreviousControler(tp)
end
function c101107061.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101107061.cfilter,1,nil,tp)
end
function c101107061.spfilter(c,e,tp)
	return c:IsCode(62651957,65622692,64500000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101107061.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101107061.spfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101107061.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101107061.spfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end