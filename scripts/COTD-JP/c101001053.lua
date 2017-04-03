--トリックスター・ライトステージ
--Trickster Lightstage
--Scripted by Eerie Code
function c101001053.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c101001053.activate)
	c:RegisterEffect(e1)
	--lock
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101001053,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c101001053.target)
	e2:SetOperation(c101001053.operation)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(c101001053.damcon1)
	e3:SetOperation(c101001053.damop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_DAMAGE)
	e4:SetCondition(c101001053.damcon2)
	c:RegisterEffect(e4)
end
function c101001053.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1fb) and c:IsAbleToHand()
end
function c101001053.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c101001053.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101001053,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c101001053.cfilter(c)
	return c:IsFacedown() and c:GetSequence()<5
end
function c101001053.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_SZONE) and c101001053.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101001053.cfilter,tp,0,LOCATION_SZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101001053,2))
	local g=Duel.SelectTarget(tp,c101001053.cfilter,tp,0,LOCATION_SZONE,1,1,e:GetHandler())
end
function c101001053.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFacedown() and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
		e:SetLabelObject(tc)
		tc:RegisterFlagEffect(101001053,RESET_EVENT+0x1fe0000,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DRAW)
		e1:SetCondition(c101001053.rcon)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		--Activate or send
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e2:SetRange(LOCATION_FZONE)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DRAW)
		e2:SetLabelObject(tc)
		e2:SetOperation(c101001053.agop)
		c:RegisterEffect(e2)
	end
end
function c101001053.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler()) and e:GetHandler():GetFlagEffect(101001053)~=0
end
function c101001053.agop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc or tc:IsFaceup() or not tc:IsLocation(LOCATION_SZONE) then return end
	tc:ResetFlagEffect(101001053)
	local act=false
	local te=tc:GetActivateEffect()
	local tep=tc:GetControler()
	local condition=nil
	local cost=nil
	local target=nil
	local operation=nil
	if te then
		condition=te:GetCondition()
		cost=te:GetCost()
		target=te:GetTarget()
		operation=te:GetOperation()
		act=te:GetCode()==EVENT_FREE_CHAIN and te:IsActivatable(tep)
			and (not condition or condition(te,tep,eg,ep,ev,re,r,rp))
			and (not cost or cost(te,tep,eg,ep,ev,re,r,rp,0))
			and (not target or target(te,tep,eg,ep,ev,re,r,rp,0))
	end
	local op=0
	if act then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPTION)
		op=Duel.SelectOption(tep,aux.Stringid(101001053,3),aux.Stringid(101001053,4))
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPTION)
		op=Duel.SelectOption(tep,aux.Stringid(101001053,4))+1
	end
	if op==0 then
		Duel.ClearTargetCard()
		e:SetProperty(te:GetProperty())
		Duel.ChangePosition(tc,POS_FACEUP)
		Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
		tc:CreateEffectRelation(te)
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		if target then target(te,tep,eg,ep,ev,re,r,rp,1) end
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local tg=nil
		if g then
			tg=g:GetFirst()
			while tg do
				tg:CreateEffectRelation(te)
				tg=g:GetNext()
			end
		end
		tc:SetStatus(STATUS_ACTIVATED,true)
		if operation then operation(te,tep,eg,ep,ev,re,r,rp) end
		tc:ReleaseEffectRelation(te)
		if g then
			tg=g:GetFirst()
			while tg do
				tg:ReleaseEffectRelation(te)
				tg=g:GetNext()
			end
		end
		if bit.band(tc:GetType(),TYPE_CONTINUOUS)==0 then
			Duel.SendtoGrave(tc,REASON_RULE)
		end
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function c101001053.damcon1(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and eg:GetFirst():IsSetCard(0x1fb)
end
function c101001053.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and bit.band(r,REASON_BATTLE)==0 and re 
		and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x1fb)
end
function c101001053.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,101001053)
	Duel.Damage(1-tp,200,REASON_EFFECT)
end
