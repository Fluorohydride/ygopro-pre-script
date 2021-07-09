--Rokket Caliber
--scripted by XyLeN
function c100280001.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100280001+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100280001.spcon) 
	e1:SetValue(c100280001.spval)
	c:RegisterEffect(e1)
	--spsummon 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100280001,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100280001+100)
	e2:SetCost(c100280001.spcost)
	e2:SetTarget(c100280001.sptg2)
	e2:SetOperation(c100280001.spop2)
	c:RegisterEffect(e2)
end
function c100280001.linkedfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_LINK)
end
function c100280001.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler() 
	local g=Duel.GetMatchingGroup(c100280001.linkedfilter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()<=0 then return false end
	local zone=0
	local tc=g:GetFirst() 
	while tc do
		zone=bit.bor(zone,tc:GetLinkedZone(tp))
		tc=g:GetNext()
	end
	zone=bit.band(zone,0x1f)
	return zone and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c100280001.spval(e,c) 
	local tp=c:GetControler() 
	local g=Duel.GetMatchingGroup(c100280001.linkedfilter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()<=0 then return end
	local zone=0
	local tc=g:GetFirst()
	while tc do
		zone=bit.bor(zone,tc:GetLinkedZone(tp))
		tc=g:GetNext()
	end
	zone=bit.band(zone,0x1f)
	return 0,zone
end
function c100280001.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() end
	Duel.Release(c,REASON_COST)
end
function c100280001.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_DRAGON+RACE_MACHINE)
		and not c:IsCode(100280001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100280001.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100280001.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c100280001.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100280001.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
