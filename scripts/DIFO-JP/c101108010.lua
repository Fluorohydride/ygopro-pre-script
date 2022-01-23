--スケアクロー・ベロネア
--
--HanamomoHakune
function c101108010.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101108010+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101108010.hspcon)
	e1:SetValue(c101108010.hspval)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PIERCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c101108010.ptg)
	c:RegisterEffect(e2)
end
function c101108010.cfilter(c)
	return c:IsSetCard(0x27b) and c:IsFaceup()
end
function c101108010.getzone(tp)
	local zone=0
	local g=Duel.GetMatchingGroup(c101108010.cfilter,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local seq=aux.MZoneSequence(tc:GetSequence())
		zone=zone|(1<<seq)
		if seq>0 then zone=zone|(1<<(seq-1)) end
		if seq<4 then zone=zone|(1<<(seq+1)) end
	end
	return zone
end
function c101108010.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=c101108010.getzone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c101108010.hspval(e,c)
	local tp=c:GetControler()
	return 0,c101108010.getzone(tp)
end
function c101108010.ptg(e,c)
	return c:IsSetCard(0x27b) and c:GetSequence()>=5
end
