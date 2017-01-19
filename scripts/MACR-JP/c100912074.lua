--幻煌龍の天渦
--Celestial Whirlpool of the Mythic Radiance Dragon
--Script by nekrozar
function c100912074.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100912074.target)
	e1:SetOperation(c100912074.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c100912074.handcon)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(c100912074.reptg)
	e3:SetValue(c100912074.repval)
	e3:SetOperation(c100912074.repop)
	c:RegisterEffect(e3)
end
function c100912074.filter(c)
	return c:IsFaceup() and c:IsCode(100912028)
end
function c100912074.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100912074.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100912074.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c100912074.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c100912074.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e1:SetCode(EVENT_BATTLE_DESTROYING)
		e1:SetCondition(c100912074.wincon)
		e1:SetOperation(c100912074.winop)
		e1:SetOwnerPlayer(tp)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c100912074.winfilter(c)
	return c:IsSetCard(0xfa) and c:IsType(TYPE_EQUIP)
end
function c100912074.wincon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetEquipGroup():Filter(c100912074.winfilter,nil)
	return aux.bdocon(e,tp,eg,ep,ev,re,r,rp) and g:GetClassCount(Card.GetCode)>2 and c:GetBattleTarget():IsType(TYPE_EFFECT)
		and c:GetControler()==e:GetOwnerPlayer()
end
function c100912074.winop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(100912074,RESET_EVENT+0x1fe0000,0,0)
	if c:GetFlagEffect(100912074)>2 then
		local WIN_REASON_CELESTIAL_WHIRLPOOL=0x1c
		Duel.Win(tp,WIN_REASON_CELESTIAL_WHIRLPOOL)
	end
end
function c100912074.cfilter(c)
	return c:IsFaceup() and c:IsCode(22702055)
end
function c100912074.handcon(e)
	return Duel.IsExistingMatchingCard(c100912074.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsEnvironment(22702055)
end
function c100912074.repfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c100912074.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c100912074.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(100912074,0))
end
function c100912074.repval(e,c)
	return c100912074.repfilter(c,e:GetHandlerPlayer())
end
function c100912074.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
