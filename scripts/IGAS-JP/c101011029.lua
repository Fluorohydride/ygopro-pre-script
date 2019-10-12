--達磨落師

--Scripted by mallu11
function c101011029.initial_effect(c)
	--atk 0
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101011029,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_ATTACK+TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1,101011029)
	e1:SetCondition(c101011029.atkcon)
	e1:SetCost(c101011029.atkcost)
	e1:SetTarget(c101011029.atktg)
	e1:SetOperation(c101011029.atkop)
	c:RegisterEffect(e1)
	--remove overlay replace
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101011029,1))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101011129)
	e2:SetCondition(c101011029.rcon)
	e2:SetOperation(c101011029.rop)
	c:RegisterEffect(e2)
end
function c101011029.cfilter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c101011029.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c101011029.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end
function c101011029.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c101011029.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101011029.cfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	Duel.SelectTarget(tp,c101011029.cfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c101011029.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetAttack()>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c101011029.rcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and  bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_XYZ)
	and re:GetHandler():GetOverlayCount()>=ev-1 and e:GetHandler():IsAbleToRemoveAsCost() and ep==e:GetOwnerPlayer()
end
function c101011029.rop(e,tp,eg,ep,ev,re,r,rp)
	return Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
