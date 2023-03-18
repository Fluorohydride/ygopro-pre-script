--蔷薇蝴蝶
--Script by 奥克斯
function c100200233.initial_effect(c)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100200233,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLevelAbove,7))
	e1:SetValue(0x1)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(c100200233.dircon)
	c:RegisterEffect(e2)
end
function c100200233.dircon(e)
	return Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsRace),e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler(),RACE_INSECT)
end