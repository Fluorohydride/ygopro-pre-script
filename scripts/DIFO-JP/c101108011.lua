--スケアクロー・アクロア
--
--HanamomoHakune
function c101108011.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101108011+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101108011.hspcon)
	e1:SetValue(c101108011.hspval)
	c:RegisterEffect(e1)
	--extra attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c101108011.atktg)
	e2:SetValue(c101108011.atkv)
	c:RegisterEffect(e2)
end
function c101108011.cfilter1(c,e)
	local seq=c:GetSequence()
	if seq>4 then return false end
	return ((seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		  or(seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))) 
		and c:IsSetCard(0x27b) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c101108011.cfilter2(c,e)
	return c:GetColumnZone(LOCATION_MZONE,tp)>0 
		and c:IsSetCard(0x27b) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c101108011.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local lg=Duel.GetMatchingGroup(c101108011.cfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
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
	local lg1=Duel.GetMatchingGroup(c101108011.cfilter2,tp,LOCATION_MZONE,0,nil,e)
	for tc in aux.Next(lg1) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c101108011.hspval(e,c)
	local tp=c:GetControler()
	local lg=Duel.GetMatchingGroup(c101108011.cfilter1,tp,LOCATION_MZONE,0,nil,e)
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
	local lg1=Duel.GetMatchingGroup(c101108011.cfilter2,tp,LOCATION_MZONE,0,nil,e)
	for tc in aux.Next(lg1) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
	end
	return 0,zone
end
function c101108011.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsDefensePos()
end
function c101108011.atktg(e,c)
	return c:IsSetCard(0x27b) and c:IsType(TYPE_LINK) and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()>=5
end
function c101108011.atkv(e,c)
	return Duel.GetMatchingGroupCount(c101108011.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)*300
end
