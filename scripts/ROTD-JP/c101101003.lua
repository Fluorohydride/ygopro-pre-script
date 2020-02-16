--砲撃のカタパルト・タートル

--Scripted by mallu11
function c101101003.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101101003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101101003)
	e1:SetCost(c101101003.spcost)
	e1:SetTarget(c101101003.sptg)
	e1:SetOperation(c101101003.spop)
	c:RegisterEffect(e1)
end
function c101101003.rfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0
end
function c101101003.spfilter(c,e,tp)
	return (c:IsSetCard(0xbd) or c:IsLevel(5) and c:IsRace(RACE_DRAGON)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101101003.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101101003.rfilter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c101101003.rfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c101101003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101101003.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c101101003.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101101003.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
