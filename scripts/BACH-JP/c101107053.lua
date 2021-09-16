function c101107053.initial_effect(c)
	--activate 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c101107053.disop)
	c:RegisterEffect(e2)
	--destroy 
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,101107053)
	e3:SetCondition(c101107053.descon)
	e3:SetOperation(c101107053.desop)
	c:RegisterEffect(e3)
end
c101107053[0]=0
function c101107053.disfilter(c)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_FIEND) and c:IsLevelAbove(8) and c:IsFaceup()
end
function c101107053.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local id=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	if ep==tp or id==c101107053[0] or not re:IsActiveType(TYPE_MONSTER)
		or (not re:GetHandler():IsAttack(0) and not re:GetHandler():IsDefense(0))
		or not Duel.IsExistingMatchingCard(c101107053.disfilter,tp,LOCATION_MZONE,0,1,nil)
		or c:GetFlagEffect(101107053)>0
		then return end
	c101107053[0]=id
	if Duel.SelectYesNo(tp,aux.Stringid(101107053,0)) then
		Duel.NegateEffect(ev)
		c:RegisterFlagEffect(101107053,RESET_PHASE+PHASE_END,0,0)
	end
end
function c101107053.descon(e,tp,eg,ep,ev,re,r,rp)
	local a,d=Duel.GetBattleMonster(tp)
	return a:IsAttack(0) and d:IsAttack(0)
end
function c101107053.desop(e,tp,eg,ep,ev,re,r,rp)
	local a,d=Duel.GetBattleMonster(tp)
	if d then
		Duel.Destroy(d,REASON_EFFECT)
	end
end