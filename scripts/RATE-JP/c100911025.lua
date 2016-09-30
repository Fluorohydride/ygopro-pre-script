--混沌の使者
--Envoy of Chaos
--Script by nekrozar
function c100911025.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100911025,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c100911025.atkcon1)
	e1:SetCost(c100911025.atkcost)
	e1:SetTarget(c100911025.atktg1)
	e1:SetOperation(c100911025.atkop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100911025,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCost(c100911025.thcost)
	e2:SetTarget(c100911025.thtg)
	e2:SetOperation(c100911025.thop)
	c:RegisterEffect(e2)
end
function c100911025.atkcon1(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and (ph~=PHASE_DAMAGE or not Duel.IsDamageCalculated())
end
function c100911025.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c100911025.atkfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x10cf) or c:IsSetCard(0xbd))
end
function c100911025.atktg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100911025.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100911025.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c100911025.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c100911025.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		tc:RegisterFlagEffect(100911025,RESET_EVENT+0x1220000+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1500)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_SET_ATTACK_FINAL)
		e2:SetTargetRange(0,LOCATION_MZONE)
		e2:SetCondition(c100911025.atkcon2)
		e2:SetTarget(c100911025.atktg2)
		e2:SetValue(c100911025.atkval)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c100911025.atkcon2(e)
	local tc=e:GetLabelObject()
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL
		and tc:GetFlagEffect(100911025)~=0 and tc:GetBattleTarget()
end
function c100911025.atktg2(e,c)
	return c==e:GetLabelObject():GetBattleTarget()
end
function c100911025.atkval(e,c)
	return c:GetBaseAttack()
end
function c100911025.cfilter(c,att)
	return c:IsAttribute(att) and c:IsAbleToRemoveAsCost()
end
function c100911025.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c100911025.cfilter,tp,LOCATION_GRAVE,0,1,c,ATTRIBUTE_LIGHT)
		and Duel.IsExistingMatchingCard(c100911025.cfilter,tp,LOCATION_GRAVE,0,1,c,ATTRIBUTE_DARK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c100911025.cfilter,tp,LOCATION_GRAVE,0,1,1,c,ATTRIBUTE_LIGHT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c100911025.cfilter,tp,LOCATION_GRAVE,0,1,1,c,ATTRIBUTE_DARK)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c100911025.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c100911025.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
