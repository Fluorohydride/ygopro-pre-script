--太陽神合一

--Scripted by mallu11
function c100424007.initial_effect(c)
	aux.AddCodeList(c,10000010)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--act in set turn
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCondition(c100424007.actcon)
	c:RegisterEffect(e1)
	--atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100424007,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c100424007.atkcon)
	e2:SetCost(c100424007.atkcost)
	e2:SetTarget(c100424007.atktg)
	e2:SetOperation(c100424007.atkop)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100424007,1))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1)
	e3:SetCost(c100424007.reccost)
	e3:SetTarget(c100424007.rectg)
	e3:SetOperation(c100424007.recop)
	c:RegisterEffect(e3)
end
function c100424007.actfilter(c)
	return c:IsFaceup() and c:IsOriginalCodeRule(10000010)
end
function c100424007.actcon(e)
	return Duel.IsExistingMatchingCard(c100424007.actfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c100424007.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c100424007.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100,0)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLP(tp)>100 and c:GetFlagEffect(100424107)==0 end
	local lp=Duel.GetLP(tp)
	e:SetLabel(100,lp-100)
	Duel.PayLPCost(tp,lp-100)
	c:RegisterFlagEffect(100424007,RESET_CHAIN,0,1)
end
function c100424007.atkfilter(c)
	return c:IsFaceup() and c:IsCode(10000010) and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c100424007.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local label,atk=e:GetLabel()
	if chk==0 then
		e:SetLabel(0,atk)
		if label~=100 then return false end
		return Duel.IsExistingMatchingCard(c100424007.atkfilter,tp,LOCATION_MZONE,0,1,nil)
	end
end
function c100424007.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c100424007.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		local label,atk=e:GetLabel()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end
function c100424007.recfilter(c)
	return c:IsCode(10000010) and c:GetAttack()>0
end
function c100424007.reccost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100,0)
	local c=e:GetHandler()
	if chk==0 then return Duel.CheckReleaseGroup(tp,c100424007.recfilter,1,nil) and c:GetFlagEffect(100424007)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c100424007.recfilter,1,1,nil)
	e:SetLabel(100,g:GetFirst():GetAttack())
	Duel.Release(g,REASON_COST)
	c:RegisterFlagEffect(100424107,RESET_CHAIN,0,1)
end
function c100424007.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local label,rec=e:GetLabel()
	if chk==0 then
		e:SetLabel(0,0)
		if label~=100 then return false end
		return true
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c100424007.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
