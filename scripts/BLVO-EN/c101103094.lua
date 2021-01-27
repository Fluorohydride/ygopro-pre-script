--War Rock Gactos
--Scripted by Kohana Sonogami
function c101103094.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101103094,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,101103094)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101103094.spcon1)
	e1:SetTarget(c101103094.sptg1)
	e1:SetOperation(c101103094.spop1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101103094,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,101103094+100)
	e2:SetCondition(c101103094.spcon2)
	e2:SetTarget(c101103094.sptg2)
	e2:SetOperation(c101103094.spop2)
	c:RegisterEffect(e2)
end
function c101103094.cfilter(c,tp)
	return c:IsFaceup() and (c:IsSetCard(0x263) and c:IsType(TYPE_MONSTER) or c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_WARRIOR))
		and c:IsControler(tp)
end
function c101103094.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101103094.cfilter,1,nil,tp)
end
function c101103094.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101103094.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c101103094.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsPreviousLocation(LOCATION_MZONE) and c:IsReason(REASON_EFFECT)
end
function c101103094.spfilter2(c,e,tp)
	return c:IsLevelAbove(5) and c:IsSetCard(0x263) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101103094.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101103094.spfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c101103094.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101103094.spfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
