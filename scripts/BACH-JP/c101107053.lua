--烙印の使徒
--
--Script by Trishula9
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
function c101107053.disfilter(c)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_FIEND) and c:IsLevelAbove(8) and c:IsFaceup()
end
function c101107053.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if rp==1-tp and c:GetFlagEffect(101107053)==0
		and re:IsActiveType(TYPE_MONSTER) and (rc:IsAttack(0) or rc:IsDefense(0))
		--and rc:IsRelateToEffect(re) and rc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED)
		--and (rc:IsFaceup() or rc:IsLocation(LOCATION_GRAVE))
		and Duel.IsExistingMatchingCard(c101107053.disfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.SelectEffectYesNo(tp,c,aux.Stringid(101107053,0)) then
		Duel.Hint(HINT_CARD,0,101107053)
		Duel.NegateEffect(ev)
		c:RegisterFlagEffect(101107053,RESET_PHASE+PHASE_END,0,0)
	end
end
function c101107053.descon(e,tp,eg,ep,ev,re,r,rp)
	local a,d=Duel.GetBattleMonster(tp)
	return a and d and a:IsAttack(0) and d:IsAttack(0)
end
function c101107053.desop(e,tp,eg,ep,ev,re,r,rp)
	local a,d=Duel.GetBattleMonster(tp)
	if d then
		Duel.Destroy(d,REASON_EFFECT)
	end
end
