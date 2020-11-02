--光天のマハー・ヴァイロ
--Lightsky Maha Vailo
--Script by: XGlitchy30
function c101103024.initial_effect(c)
	--atk boost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetLabel(1)
	e1:SetCondition(c101103024.eqcon)
	e1:SetValue(c101103024.atkval)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetLabel(2)
	e2:SetCondition(c101103024.eqcon)
	e2:SetValue(c101103024.actlimit)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabel(3)
	e3:SetCondition(c101103024.eqcon)
	e3:SetCost(c101103024.negcost)
	e3:SetTarget(c101103024.negtg)
	e3:SetOperation(c101103024.negop)
	c:RegisterEffect(e3)
	--actlimit2
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetTargetRange(0,1)
	e4:SetLabel(4)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c101103024.eqcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--double damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e5:SetLabel(5)
	e5:SetCondition(c101103024.eqcon)
	e5:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e5)
end
function c101103024.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lab=e:GetLabel()
	if c:GetEquipCount()<lab then return false end
	if (lab==2 or lab==4) then
		return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
	elseif lab==3 then
		if rp==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
			return false
		end
		local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		return g and g:IsContains(c) and Duel.IsChainDisablable(ev)
	else
		return true
	end
end
function c101103024.atkval(e,c)
	return c:GetEquipCount()*1000
end
function c101103024.actlimit(e,re,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c101103024.negfilter(c)
	return (c:IsFaceup() or c:GetEquipTarget()) and c:IsType(TYPE_EQUIP) and c:IsAbleToGraveAsCost()
end
function c101103024.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101103024.negfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101103024.negfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c101103024.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c101103024.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
