--水精鱗－ネレイアビス
--Mermail Abyssnelia
--Scripted by Eerie Code
function c101002028.initial_effect(c)
	--increase atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101002028,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101002028)
	e1:SetCondition(c101002028.atkcon)
	e1:SetCost(c101002028.atkcost)
	e1:SetTarget(c101002028.atktg)
	e1:SetOperation(c101002028.atkop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e2:SetDescription(aux.Stringid(101002028,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,101002028+100)
	e2:SetCondition(c101002028.drcon)
	e2:SetTarget(c101002028.drtg)
	e2:SetOperation(c101002028.drop)
	c:RegisterEffect(e2)
end
function c101002028.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c101002028.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c101002028.atkfilter1(c,mg)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
		and c:IsLocation(LOCATION_MZONE)
		and mg:IsExists(aux.TRUE,1,c)
end
function c101002028.atkfilter2(c,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
		and Duel.IsExistingMatchingCard(c101002028.desfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,c)
end
function c101002028.desfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and (c:GetBaseAttack()>0 or c:GetBaseDefense()>0)
end
function c101002028.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c101002028.atkfilter2(chkc,tp) end
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c101002028.desfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,e:GetHandler())
		return Duel.IsExistingTarget(c101002028.atkfilter1,tp,LOCATION_MZONE,0,1,nil,mg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101002028.atkfilter2,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE+LOCATION_HAND)
end
function c101002028.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dc=Duel.SelectMatchingCard(tp,c101002028.desfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,tc):GetFirst()
	if dc and Duel.Destroy(dc,REASON_EFFECT)~=0 then
		if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(dc:GetBaseAttack())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(dc:GetBaseDefense())
		tc:RegisterEffect(e2)
	end
end
function c101002028.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c101002028.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101002028.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
