--ブリザード

--Scripted by mallu11
function c101101063.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101101063+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101101063.target)
	e1:SetOperation(c101101063.activate)
	c:RegisterEffect(e1)
end
function c101101063.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function c101101063.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c101101063.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101101063.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101101063.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c101101063.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local code=tc:GetOriginalCodeRule()
		--disable
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetLabel(code)
		e1:SetCondition(c101101063.discon)
		e1:SetOperation(c101101063.disop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	if tc:IsRelateToEffect(e) then
		--redirect
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e2:SetValue(LOCATION_HAND)
		e2:SetCondition(c101101063.recon)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetOwnerPlayer(tp)
		tc:RegisterEffect(e2,true)
	end
end
function c101101063.discon(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return re:GetHandler():IsOriginalCodeRule(code) and re:IsActiveType(TYPE_SPELL) and loc&LOCATION_ONFIELD~=0
end
function c101101063.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c101101063.recon(e)
	return e:GetHandler():GetOwner()~=e:GetOwnerPlayer()
end
