--副話術士クララ＆ルーシカ

--Script by nekrozar
function c101003049.initial_effect(c)
	c:EnableReviveLimit()
	--link summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c101003049.lkcon)
	e1:SetOperation(c101003049.lkop)
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
end
function c101003049.lkfilter(c,lc,tp)
	return c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and c:IsSummonType(SUMMON_TYPE_NORMAL) and Duel.GetLocationCountFromEx(tp,tp,c,lc)>0
end
function c101003049.lkcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	return Duel.GetCurrentPhase()==PHASE_MAIN2
		and Duel.IsExistingMatchingCard(c101003049.lkfilter,tp,LOCATION_MZONE,0,1,nil,c,tp)
end
function c101003049.lkop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,c101003049.lkfilter,tp,LOCATION_MZONE,0,1,1,nil,c,tp)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
end
