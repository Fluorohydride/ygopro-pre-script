--螺旋砲撃

--Scripted by mallu11
function c101101068.initial_effect(c)
	aux.AddCodeList(c,66889139)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--atklimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCondition(c101101068.tgcon)
	e1:SetValue(c101101068.tgtg)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c101101068.tgcon)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101101068,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,101101068)
	e3:SetCondition(c101101068.descon)
	e3:SetTarget(c101101068.destg)
	e3:SetOperation(c101101068.desop)
	c:RegisterEffect(e3)
end
function c101101068.tgfilter(c)
	return c:IsFaceup() and c:IsCode(66889139)
end
function c101101068.tgcon(e)
	return Duel.IsExistingMatchingCard(c101101068.tgfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c101101068.tgtg(e,c)
	return c:IsFacedown() or not c:IsCode(66889139)
end
function c101101068.descon(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	local tc=Duel.GetAttackTarget()
	if not ac:IsControler(tp) then ac,tc=tc,ac end
	return ac and ac:IsControler(tp) and ac:IsFaceup() and ac:IsCode(66889139)
end
function c101101068.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101101068.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
