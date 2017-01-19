--ファイヤークラッカー
--Fire Cracker
--Script by nekrozar
function c100912035.initial_effect(c)
	c:EnableCounterPermit(0x42)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100912035,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100912035)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c100912035.damcost1)
	e1:SetTarget(c100912035.damtg1)
	e1:SetOperation(c100912035.damop1)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c100912035.ctcon)
	e2:SetOperation(c100912035.ctop)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100912035,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c100912035.damtg2)
	e3:SetOperation(c100912035.damop2)
	c:RegisterEffect(e3)
end
function c100912035.damcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c100912035.damtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c100912035.damop1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Damage(p,d,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_SKIP_DP)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
		Duel.RegisterEffect(e1,tp)
	end
end
function c100912035.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and bit.band(r,REASON_EFFECT)~=0
end
function c100912035.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x42,1)
end
function c100912035.damtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=e:GetHandler():GetCounter(0x42)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct)
end
function c100912035.damop2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x42)
	if ct>0 then
		c:RemoveCounter(tp,0x42,ct,REASON_EFFECT)
		Duel.Damage(p,ct,REASON_EFFECT)
	end
end
