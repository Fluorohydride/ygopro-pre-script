--天火の牢獄
--Fire Prison
--Script by nekrozar
function c101003052.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--defup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_DRAGON))
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--cannot link summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(1,1)
	e3:SetTarget(c101003052.splimit)
	c:RegisterEffect(e3)
	--cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ATTACK)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c101003052.atktg)
	c:RegisterEffect(e4)
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCondition(c101003052.discon)
	e5:SetOperation(c101003052.disop)
	c:RegisterEffect(e5)
	--cannot attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_ATTACK)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetCondition(c101003052.limcon)
	e6:SetTarget(c101003052.atlimit)
	c:RegisterEffect(e6)
	--cannot be battle target
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e7:SetRange(LOCATION_FZONE)
	e7:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e7:SetCondition(c101003052.limcon)
	e7:SetValue(c101003052.atlimit)
	c:RegisterEffect(e7)
	--cannot be effect target
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e8:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e8:SetRange(LOCATION_FZONE)
	e8:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e8:SetCondition(c101003052.limcon)
	e8:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_CYBERS))
	e8:SetValue(1)
	c:RegisterEffect(e8)
end
function c101003052.limfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c101003052.splimit(e,c,tp,sumtp,sumpos)
	local g=Duel.GetMatchingGroup(c101003052.limfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local mg,lk=g:GetMinGroup(Card.GetLink)
	return lk>c:GetLink() and bit.band(sumtp,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c101003052.atktg(e,c)
	return not c:IsType(TYPE_LINK)
end
function c101003052.cfilter(c)
	return c:IsFaceup() and c:IsType(RACE_CYBERS)
end
function c101003052.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c101003052.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)>1
		and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsRace(RACE_CYBERS)
end
function c101003052.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c101003052.limcon(e)
	return Duel.GetMatchingGroupCount(c101003052.cfilter,e:GetHandler():GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)>1
end
function c101003052.atlimit(e,c)
	return c:IsFaceup() and c:IsType(RACE_CYBERS)
end
