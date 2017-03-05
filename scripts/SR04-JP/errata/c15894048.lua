--究極恐獣
function c15894048.initial_effect(c)
	--limit attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c15894048.attg)
	e1:SetCondition(c15894048.atcon)
	c:RegisterEffect(e1)
	--attack all
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c15894048.attg(e,c)
	return not c:IsCode(15894048)
end
function c15894048.atfilter(c)
	return c:IsFaceup() and c:IsCode(15894048) and c:IsAttackable()
end
function c15894048.atcon(e)
	return Duel.IsExistingMatchingCard(c15894048.atfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
