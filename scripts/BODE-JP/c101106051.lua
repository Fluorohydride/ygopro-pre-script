--Evil★Twin's トラブル・サニー
--
--Script by 222DIY-KillerDJ
function c101106051.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,4,c101106051.lcheck)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101106051,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101106051)
	e1:SetCost(c101106051.spcost)
	e1:SetTarget(c101106051.sptg)
	e1:SetOperation(c101106051.spop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101106051,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101106051+100)
	e2:SetCost(c101106051.rmcost)
	e2:SetTarget(c101106051.rmtg)
	e2:SetOperation(c101106051.rmop)
	c:RegisterEffect(e2)
end
function c101106051.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x2151)
end
function c101106051.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c101106051.spfilter1(c,e,tp)
	return c:IsSetCard(0x152) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c101106051.spfilter2,tp,LOCATION_GRAVE,0,1,c,e,tp)
end
function c101106051.spfilter2(c,e,tp)
	return c:IsSetCard(0x153) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101106051.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>1
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsExistingMatchingCard(c101106051.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end
function c101106051.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2
		or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101106051.spfilter1),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101106051.spfilter2),tp,LOCATION_GRAVE,0,1,1,g1:GetFirst(),e,tp)
	g1:Merge(g2)
	if g1:GetCount()==2 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101106051.costfilter(c,tp)
	return c:IsSetCard(0x2151) and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_HAND+LOCATION_DECK) or c:IsFaceup()) 
		and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function c101106051.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c101106051.costfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101106051.costfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.SendtoGrave(g,REASON_COST)
end
function c101106051.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c101106051.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
