--レッド・ガードナー
--Red Gardna
--Script by mercury233
function c100909015.initial_effect(c)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c100909015.condition)
	e1:SetCost(c100909015.cost)
	e1:SetOperation(c100909015.operation)
	c:RegisterEffect(e1)
end
function c100909015.filter(c)
	return c:IsSetCard(0x1045) and c:IsFaceup()
end
function c100909015.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.IsExistingMatchingCard(c100909015.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c100909015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c100909015.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(c100909015.indval)
	Duel.RegisterEffect(e1,tp)
end
function c100909015.indval(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
