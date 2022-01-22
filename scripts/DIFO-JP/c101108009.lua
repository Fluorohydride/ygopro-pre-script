--スケアクロー・アストラ
--
--HanamomoHakune
function c101108009.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101108009+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101108009.hspcon)
	e1:SetValue(c101108009.hspval)
	c:RegisterEffect(e1)
	--extra attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c101108009.exatkcon)
	e2:SetTarget(c101108009.exatktg)
	e2:SetValue(c101108009.exarkval)
	c:RegisterEffect(e2)
end
function c101108009.cfilter1(c,e)
	local seq=c:GetSequence()
	if seq>4 then return false end
	return ((seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		  or(seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))) 
		and c:IsSetCard(0x27b) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c101108009.cfilter2(c,e)
	return c:GetColumnZone(LOCATION_MZONE,tp)>0 
		and c:IsSetCard(0x27b) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c101108009.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local lg=Duel.GetMatchingGroup(c101108009.cfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local zone=0
	for tc in aux.Next(lg) do
		local seq=tc:GetSequence()	  
		if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then 
			zone=bit.bor(zone,(1<<(seq-1)))
		end
		if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then 
			zone=bit.bor(zone,(1<<(seq+1)))
		end
	end
	local lg1=Duel.GetMatchingGroup(c101108009.cfilter2,tp,LOCATION_MZONE,0,nil,e)
	for tc in aux.Next(lg1) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c101108009.hspval(e,c)
	local tp=c:GetControler()
	local lg=Duel.GetMatchingGroup(c101108009.cfilter1,tp,LOCATION_MZONE,0,nil,e)
	local zone=0
	for tc in aux.Next(lg) do
		local seq=tc:GetSequence()	  
		if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then 
			zone=bit.bor(zone,(1<<(seq-1)))
		end
		if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then 
			zone=bit.bor(zone,(1<<(seq+1)))
		end
	end
	local lg1=Duel.GetMatchingGroup(c101108009.cfilter2,tp,LOCATION_MZONE,0,nil,e)
	for tc in aux.Next(lg1) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
	end
	return 0,zone
end
function c101108009.deffilter(c)
	return c:IsDefensePos() and c:IsSetCard(0x27b) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c101108009.exatkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c101108009.deffilter,tp,LOCATION_MZONE,0,nil)>1
end
function c101108009.exatktg(e,c)
	return c:IsSetCard(0x27b) and c:IsType(TYPE_LINK) and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()>=5
end
function c101108009.exarkval(e,c)
	return Duel.GetMatchingGroupCount(c101108009.deffilter,tp,LOCATION_MZONE,0,nil)-1
end
