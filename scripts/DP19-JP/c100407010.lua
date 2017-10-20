--蝕みの鱗粉
--Corrosive Scales
--Script by nekrozar
function c100407010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c100407010.target)
	e1:SetOperation(c100407010.activate)
	c:RegisterEffect(e1)
end
function c100407010.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT)
end
function c100407010.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100407010.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100407010.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c100407010.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c100407010.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) then return end
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		c:CancelToGrave()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(c100407010.eqlimit)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
		e2:SetRange(LOCATION_SZONE)
		e2:SetTargetRange(0,LOCATION_MZONE)
		e2:SetCondition(c100407010.atkcon1)
		e2:SetValue(c100407010.atktg)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetRange(LOCATION_SZONE)
		e3:SetCode(EVENT_SUMMON_SUCCESS)
		e3:SetCondition(c100407010.ctcon1)
		e3:SetOperation(c100407010.ctop)
		c:RegisterEffect(e2)
		local e4=e3:Clone()
		e4:SetCode(EVENT_SPSUMMON_SUCCESS)
		c:RegisterEffect(e4)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_CHAINING)
		e5:SetRange(LOCATION_SZONE)
		e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e5:SetOperation(c100407010.regop)
		c:RegisterEffect(e5)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e6:SetCode(EVENT_CHAIN_SOLVED)
		e6:SetRange(LOCATION_SZONE)
		e6:SetCondition(c100407010.ctcon2)
		e6:SetOperation(c100407010.ctop)
		c:RegisterEffect(e6)
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_FIELD)
		e7:SetCode(EFFECT_UPDATE_ATTACK)
		e7:SetRange(LOCATION_SZONE)
		e7:SetTargetRange(0,LOCATION_MZONE)
		e7:SetCondition(c100407010.atkcon2)
		e7:SetValue(c100407010.atkval)
		c:RegisterEffect(e7)
		local e8=e7:Clone()
		e8:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e8)
	end
end
function c100407010.eqlimit(e,c)
	return c:GetControler()==e:GetHandlerPlayer() or e:GetHandler():GetEquipTarget()==c
end
function c100407010.atkcon1(e)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ec:GetControler()==e:GetHandlerPlayer()
end
function c100407010.atktg(e,c)
	return c~=e:GetHandler():GetEquipTarget()
end
function c100407010.cfilter(c,tp)
	return c:GetSummonPlayer()==tp
end
function c100407010.ctcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget() and eg:IsExists(c100407010.cfilter,1,nil,1-tp)
end
function c100407010.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,100407010)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1045,1)
		tc=g:GetNext()
	end
end
function c100407010.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(100407010,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)
end
function c100407010.ctcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget() and ep~=tp and c:GetFlagEffect(100407010)~=0
end
function c100407010.atkcon2(e)
	return e:GetHandler():GetEquipTarget()
end
function c100407010.atkval(e,c)
	return c:GetCounter(0x1045)*-100
end
