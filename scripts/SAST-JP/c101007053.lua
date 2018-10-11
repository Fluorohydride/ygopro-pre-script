--守護竜アガーペイン

--Script by nekrozar
function c101007053.initial_effect(c)
	c:SetSPSummonOnce(101007053)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_DRAGON),2,2)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101007053.splimit)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101007053,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101007053)
	e2:SetTarget(c101007053.sptg)
	e2:SetOperation(c101007053.spop)
	c:RegisterEffect(e2)
end
function c101007053.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsRace(RACE_DRAGON)
end
function c101007053.lkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c101007053.spfilter(c,e,tp,zone)
	return c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c101007053.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg1=Duel.GetMatchingGroup(c101007053.lkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local zone=0
	for tc1 in aux.Next(lg1) do
		local zone1=bit.band(tc1:GetLinkedZone(),0x7f)
		local lg2=Duel.GetMatchingGroup(c101007053.lkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,tc1)
		for tc2 in aux.Next(lg2) do
			local zone2=bit.band(zone1,bit.band(tc2:GetLinkedZone(),0x7f))
			if zone2~=0 then
				zone=bit.bor(zone,zone2)
			end
		end
	end
	if chk==0 then return zone~=0 and Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c101007053.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101007053.spop(e,tp,eg,ep,ev,re,r,rp)
	local lg1=Duel.GetMatchingGroup(c101007053.lkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local zone=0
	for tc1 in aux.Next(lg1) do
		local zone1=bit.band(tc1:GetLinkedZone(),0x7f)
		local lg2=Duel.GetMatchingGroup(c101007053.lkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,tc1)
		for tc2 in aux.Next(lg2) do
			local zone2=bit.band(zone1,bit.band(tc2:GetLinkedZone(),0x7f))
			if zone2~=0 then
				zone=bit.bor(zone,zone2)
			end
		end
	end
	if Duel.GetLocationCountFromEx(tp)<=0 or zone==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101007053.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
