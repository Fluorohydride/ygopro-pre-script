--捕食植物モーレイ・ネペンテス
--Predator Plant Moray Nepenthes
--Script by dest
function c100910007.initial_effect(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c100910007.atkval)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100910007,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(aux.bdocon)
	e2:SetTarget(c100910007.eqtg)
	e2:SetOperation(c100910007.eqop)
	c:RegisterEffect(e2)
	--destroy + lp gain
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100910007,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c100910007.target)
	e3:SetOperation(c100910007.operation)
	c:RegisterEffect(e3)
end
function c100910007.atkval(e,c)
	return Duel.GetCounter(0,1,1,0x1141)*200
end
function c100910007.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	local bc=e:GetHandler():GetBattleTarget()
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,bc,1,0,0)
end
function c100910007.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
		if not Duel.Equip(tp,tc,c,false) then return end
		--Add Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c100910007.eqlimit)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(100910007,RESET_EVENT+0x1fe0000,0,1)
	end
end
function c100910007.eqlimit(e,c)
	return e:GetOwner()==c
end
function c100910007.desfilter(c,ec)
	return c:IsDestructable() and c:GetFlagEffect(100910007)~=0 and c:GetEquipTarget()==ec
end
function c100910007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c100910007.desfilter(chkc,c) end
	if chk==0 then return Duel.IsExistingTarget(c100910007.desfilter,tp,LOCATION_SZONE,0,1,nil,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c100910007.desfilter,tp,LOCATION_SZONE,0,1,1,nil,c)
	local atk=g:GetFirst():GetTextAttack()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
end
function c100910007.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		local atk=tc:GetTextAttack()
		Duel.Recover(tp,atk,REASON_EFFECT)
	end
end
