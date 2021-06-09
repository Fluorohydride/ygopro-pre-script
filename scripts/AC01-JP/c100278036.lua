--LL-バード・ストライク 魔
--scripted by XyLeN
function c100278036.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100278036+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100278036.condition)
	e1:SetTarget(c100278036.target)
	e1:SetOperation(c100278036.activate)
	c:RegisterEffect(e1)
end
function c100278036.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf7) 
end
function c100278036.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100278036.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100278036.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.disfilter1,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c100278036.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
