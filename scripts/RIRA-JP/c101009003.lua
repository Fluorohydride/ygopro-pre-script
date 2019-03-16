--海晶少女 海马
--
--Scripted By-FW空鸽
function c101009003.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP,0)
	e1:SetCountLimit(1,101009003)
	e1:SetCondition(c101009003.spcon)
	e1:SetValue(c101009003.spval)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101009003,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101009003)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101009003.sptg)
	e2:SetOperation(c101009003.spop)
	c:RegisterEffect(e2)
end
function c101009003.checkzone(tp)
	local zone=0
	local g=Duel.GetMatchingGroup(c101009003.cfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		zone=bit.bor(zone,tc:GetLinkedZone(tp))
	end
	return zone
end
function c101009003.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x22b)
end
function c101009003.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rzone=c101009003.checkzone(tp)
	local zone=bit.band(rzone,0x1f)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c101009003.spval(e,c)
	return 0,Duel.GetLinkedZone(c:GetControler())
end
function c101009003.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101009003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rzone=c101009003.checkzone(tp)
	local zone=bit.band(rzone,0x1f)
	if chk==0 then return zone~=0
		and Duel.IsExistingMatchingCard(c101009003.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c101009003.spop(e,tp,eg,ep,ev,re,r,rp)
	local rzone=c101009003.checkzone(tp)
	local zone=bit.band(rzone,0x1f)
	if zone<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101009003.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end