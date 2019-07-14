--星遺物の導く先

--Scripted by nekrozar
function c101010061.initial_effect(c)
	c:SetUniqueOnField(1,0,101010061)
	c:EnableCounterPermit(0x54)
	c:SetCounterLimit(0x54,7)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c101010061.ctop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101010061,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c101010061.spcon)
	e3:SetCost(c101010061.spcost)
	e3:SetTarget(c101010061.sptg)
	e3:SetOperation(c101010061.spop)
	c:RegisterEffect(e3)
end
function c101010061.ctfilter(c)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousLevelOnField()>=5
end
function c101010061.ctop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c101010061.ctfilter,nil)
	if ct>0 then
		e:GetHandler():AddCounter(0x54,ct,true)
	end
end
function c101010061.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x54)==7
end
function c101010061.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function c101010061.spfilter(c,e,tp)
	return c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010061.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c101010061.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101010061.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101010061.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
