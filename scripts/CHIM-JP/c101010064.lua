--ご隠居の大釜

--Scripted by nekrozar
function c101010064.initial_effect(c)
	c:EnableCounterPermit(0x52)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101010064.target)
	e1:SetOperation(c101010064.activate)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101010064,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c101010064.ctcon)
	e2:SetTarget(c101010064.cttg)
	e2:SetOperation(c101010064.activate)
	c:RegisterEffect(e2)
	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101010064,1))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetTarget(c101010064.rectg)
	e4:SetOperation(c101010064.recop)
	c:RegisterEffect(e4)
	--damage
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(101010064,2))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetTarget(c101010064.damtg)
	e4:SetOperation(c101010064.damop)
	c:RegisterEffect(e4)
end
function c101010064.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanAddCounter(tp,0x52,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x52)
end
function c101010064.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x52,1)
	end
end
function c101010064.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c101010064.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x52)
end
function c101010064.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetCounter(0x52)
	if chk==0 then return ct>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*500)
end
function c101010064.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x52)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if c:IsRelateToEffect(e) and ct>0 then
		Duel.Recover(p,ct*500,REASON_EFFECT)
	end
end
function c101010064.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetCounter(0x52)
	if chk==0 then return ct>0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*300)
end
function c101010064.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x52)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if c:IsRelateToEffect(e) and ct>0 then
		Duel.Damage(p,ct*300,REASON_EFFECT)
	end
end
