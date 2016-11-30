--EMスカイ・マジシャン
--Performapal Sky Magician
--Scripted by Eerie Code
function c100912001.initial_effect(c)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100912001,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_F)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c100912001.atkcon)
	e1:SetOperation(c100912001.atkop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100912001,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100912001)
	e2:SetTarget(c100912001.thtg)
	e2:SetOperation(c100912001.thop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100912001,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(c100912001.descon)
	e3:SetTarget(c100912001.destg)
	e3:SetOperation(c100912001.desop)
	c:RegisterEffect(e3)
end
function c100912001.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==tp
end
function c100912001.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(300)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
function c100912001.thfilter(c)
	return c:IsFaceup() and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS	and c:IsAbleToHand()
end
function c100912001.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c100912001.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100912001.thfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c100912001.thfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c100912001.tffilter(c,tp)
	return c:IsSetCard(0x98) and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and c:GetActivateEffect():IsActivatable(tp)
end
function c100912001.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		local g=Duel.GetMatchingGroup(c100912001.tffilter,tp,LOCATION_HAND,0,nil,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,94) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local sc=g:Select(tp,1,1,nil):GetFirst()
			Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=sc:GetActivateEffect()
			local tep=sc:GetControler()
			local cost=te:GetCost()
			local target=te:GetTarget()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			if target then target(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(sc,EVENT_CHAIN_SOLVED,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end
function c100912001.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
end
function c100912001.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100912001.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
