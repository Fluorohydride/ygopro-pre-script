--不朽の特殊合金
--
--Script by JoyJ
function c100424037.initial_effect(c)
	aux.AddCodeList(c,77585513)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100424037,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c100424037.condition1)
	e1:SetCost(c100424037.target1)
	e1:SetOperation(c100424037.activate1)
	c:RegisterEffect(e1)
	--Activate2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100424037,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c100424037.condition2)
	e2:SetTarget(c100424037.target2)
	e2:SetOperation(c100424037.activate2)
	c:RegisterEffect(e2)
end
function c100424037.cfilter(c)
	return c:IsCode(77585513) and c:IsFaceup()
end
function c100424037.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100424037.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c100424037.filter1(c)
	return c:IsRace(RACE_MACHINE) and c:IsFaceup()
end
function c100424037.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100424037.filter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c100424037.activate1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100424037.filter1,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(c100424037.indoval)
		e1:SetOwnerPlayer(tp)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c100424037.indoval(e,re,rp)
	return rp==1-e:GetOwnerPlayer()
end
function c100424037.filter2(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_MACHINE)
end
function c100424037.condition2(e,tp,eg,ep,ev,re,r,rp)
	if not c100424037.condition1(e,tp,eg,ep,ev,re,r,rp) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and Duel.IsChainDisablable(ev) and tg:IsExists(c100424037.filter2,1,nil,tp)
end
function c100424037.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c100424037.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
