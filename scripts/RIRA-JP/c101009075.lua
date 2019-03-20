--怪蹴一色
--The Stamping of The Normal
--Script by nekrozar
function c101009075.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,101009075+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101009075.condition)
	e1:SetTarget(c101009075.target)
	e1:SetOperation(c101009075.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c101009075.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==1 and eg:GetFirst():IsFaceup()
end
function c101009075.filter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk-1)
end
function c101009075.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	local atk=tc:GetAttack()
	if chk==0 then return Duel.IsExistingMatchingCard(c101009075.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,atk) end
	tc:CreateEffectRelation(e)
	local g=Duel.GetMatchingGroup(c101009075.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,atk)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c101009075.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(c101009075.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tc:GetAttack())
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
