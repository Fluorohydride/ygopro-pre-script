--No.41 泥睡魔獣バグースカ
--Number 41: Baguska
--Script by nekrozar
function c100217042.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	--maintain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c100217042.mtcon)
	e1:SetOperation(c100217042.mtop)
	c:RegisterEffect(e1)
	--indes/cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c100217042.tgcon)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(c100217042.indval)
	c:RegisterEffect(e3)
	--pos
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SET_POSITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetCondition(c100217042.poscon)
	e4:SetTarget(c100217042.postg)
	e4:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e4)
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c100217042.discon)
	e5:SetOperation(c100217042.disop)
	c:RegisterEffect(e5)
end
c100217042.xyz_number=41
function c100217042.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c100217042.mtop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end
function c100217042.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsAttackPos()
end
function c100217042.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end
function c100217042.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsDefensePos()
end
function c100217042.postg(e,c)
	return c:IsFaceup()
end
function c100217042.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if c:IsStatus(STATUS_BATTLE_DESTROYED) or c:IsAttackPos() then return false end
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsDefensePos() and loc==LOCATION_MZONE
end
function c100217042.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
