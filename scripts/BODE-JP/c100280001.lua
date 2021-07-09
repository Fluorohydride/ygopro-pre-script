--Rokket Caliber
--scripted by XyLeN
function c100280001.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100280001,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100280001)
	e1:SetTarget(c100280001.sptg)
	e1:SetOperation(c100280001.spop)
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
function c100280001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c100280001.linkedfilter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()<=0 then return false end
	local zone=0
	local tc=g:GetFirst() 
	while tc do
		zone=bit.bor(zone,tc:GetLinkedZone(tp))
		tc=g:GetNext()
	end
	zone=bit.band(zone,0x1f)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
		and :IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100280001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(c100280001.linkedfilter,tp,LOCATION_MZONE,0,nil)
		if g:GetCount()<=0 then return end
		local zone=0
		local tc=g:GetFirst()
		while tc do
			zone=bit.bor(zone,tc:GetLinkedZone(tp))
			tc=g:GetNext()
		end
		zone=bit.band(zone,0x1f)
		if zone==0 then return end
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function c100280001.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c100280001.spfilter(c,e,tp)
	return (c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_DRAGON) or c:IsRace(RACE_MACHINE)) 
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
