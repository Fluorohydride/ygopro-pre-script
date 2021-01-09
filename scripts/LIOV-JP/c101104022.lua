--ダーク・オネスト

--Scripted by mallu11
function c101104022.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101104022,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c101104022.target1)
	e1:SetOperation(c101104022.operation1)
	c:RegisterEffect(e1)
	--atkdown
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101104022,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetCondition(c101104022.condition2)
	e2:SetCost(c101104022.cost2)
	e2:SetTarget(c101104022.target2)
	e2:SetOperation(c101104022.operation2)
	c:RegisterEffect(e2)
end
function c101104022.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c101104022.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c101104022.condition2(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return false end
	if not a:IsControler(tp) then a,d=d,a end
	e:SetLabelObject(d)
	return a:IsControler(tp) and a:IsFaceup() and a:IsAttribute(ATTRIBUTE_DARK) and d:IsControler(1-tp) and d:IsFaceup() and d:IsRelateToBattle()
end
function c101104022.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c101104022.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=e:GetLabelObject()
	if chk==0 then return d end
	Duel.SetTargetCard(d)
end
function c101104022.operation2(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetFirstTarget()
	if not (d:IsRelateToBattle() and d:IsFaceup() and d:IsControler(1-tp)) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(-d:GetAttack())
	d:RegisterEffect(e1)
end
