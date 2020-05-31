--遮断機塊ブレイカーバンクル
--Appliancer Breakerbuncle
--Scripted by TheBoos2569
function c100266036.initial_effect(c)
	--Cannot be destroyed and no battle damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100266036,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c100266036.atkcon)
	e1:SetCost(c100266036.atkcost)
	e1:SetOperation(c100266036.atkop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetTarget(c100266036.reptg)
	e2:SetValue(c100266036.repval)
	e2:SetOperation(c100266036.repop)
	c:RegisterEffect(e2)
end
function c100266036.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	if not tc then return false end
	e:SetLabelObject(tc)
	local bc=tc:GetBattleTarget()
	return bc and tc:IsSetCard(0x24b)
end
function c100266036.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c100266036.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e2,tp)
	end
end
function c100266036.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x24b)
		and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c100266036.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c100266036.repfilter,1,nil,tp)
		and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c100266036.repval(e,c)
	return c100266036.repfilter(c,e:GetHandlerPlayer())
end
function c100266036.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
