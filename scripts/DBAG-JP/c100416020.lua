--シドレミコード・ビューティア

--scripted by Xylen5967 & mercury233
function c100416020.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c100416020.actcon)
	e1:SetOperation(c100416020.actop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_CHAIN_END)
	e2:SetOperation(c100416020.subop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100416020,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,100416020)
	e3:SetTarget(c100416020.rmtg)
	e3:SetOperation(c100416020.rmop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100416020,2))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCountLimit(1)
	e4:SetCondition(c100416020.descon)
	e4:SetTarget(c100416020.destg)
	e4:SetOperation(c100416020.desop)
	c:RegisterEffect(e4)
end
function c100416020.actfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0x265) and c:IsType(TYPE_PENDULUM) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c100416020.actcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100416020.actfilter,1,nil,tp)
end
function c100416020.actop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(c100416020.chlimit)
	elseif Duel.GetCurrentChain()==1 then
		c:RegisterFlagEffect(100416020,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(c100416020.resetop)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_BREAK_EFFECT)
		e2:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e2,tp)
	end
end
function c100416020.resetop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:ResetFlagEffect(100416020)
	c:Reset()
end
function c100416020.subop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(100416020)~=0 then
		Duel.SetChainLimitTillChainEnd(c100416020.chlimit)
	end
end
function c100416020.chlimit(e,ep,tp)
	return ep==tp or e:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not e:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c100416020.rfilter(c,szone)
	return c:IsFaceup() and (c:IsType(TYPE_EFFECT) or szone and c:IsType(TYPE_SPELL+TYPE_TRAP))
end
function c100416020.pfilter(c)
	local lsc=c:GetLeftScale()
	local rsc=c:GetRightScale()
	return (lsc%2==0 or rsc%2==0) and c:IsType(TYPE_PENDULUM)
end
function c100416020.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local szone=Duel.IsExistingMatchingCard(c100416020.pfilter,tp,LOCATION_PZONE,0,1,nil)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and c100416020.rfilter(chkc,szone) end
	if chk==0 then return Duel.IsExistingTarget(c100416020.rfilter,tp,0,LOCATION_ONFIELD,1,nil,szone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c100416020.rfilter1,tp,0,LOCATION_ONFIELD,1,1,nil,szone)
end
function c100416020.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(100416020,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT+RESET_PHASE+PHASE_END)
		e1:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e1,true)
	end
end
function c100416020.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local p2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local sp1=255
	local sp2=255
	if p1 then sp1=p1:GetLeftScale() end
	if p2 then sp2=p2:GetRightScale() end
	local scale=math.min(sp1,sp2)
	local bc=c:GetBattleTarget()
	return scale<255 and bc and bc:IsFaceup() and bc:IsAttackAbove(scale*300)
end
function c100416020.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
function c100416020.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end
