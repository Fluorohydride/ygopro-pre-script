--円喚師フェアリ
--Script by Dr.Chaos
function c101111025.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101111025+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101111025.spcon)
	c:RegisterEffect(e1)
	--nontuner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_NONTUNER)
	e2:SetValue(c101111025.tnval)
	c:RegisterEffect(e2)
end
function c101111025.filter(c)
	return c:IsRace(RACE_PLANT+RACE_INSECT)
end
function c101111025.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101111025.filter,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
end
function c101111025.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler()) and c:IsRace(RACE_PLANT+RACE_INSECT)
end
