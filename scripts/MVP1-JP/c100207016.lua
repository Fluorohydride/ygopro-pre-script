--キウイ・マジシャン・ガール
--Kiwi Magician Girl
--Script by mercury233
function c100207016.initial_effect(c)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100207016,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c100207016.condition)
	e1:SetCost(c100207016.cost)
	e1:SetTarget(c100207016.target)
	e1:SetOperation(c100207016.operation)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c100207016.indtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTargetRange(0,0xff)
	e3:SetCode(EFFECT_CANNOT_SELECT_EFFECT_TARGET)
	e3:SetValue(c100207016.tglimit)
	c:RegisterEffect(e3)
end
function c100207016.condition(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==PHASE_DAMAGE and Duel.IsDamageCalculated() then return false end
	return true
end
function c100207016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c100207016.atkfilter(c)
	return c:IsSetCard(0x20a2)
end
function c100207016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100207016.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c100207016.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetMatchingGroup(c100207016.atkfilter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(c100207016.atkfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil)
	if tg:GetCount()>0 and g:GetCount()>0 then
		local d=g:GetClassCount(Card.GetCode)*300
		local sc=tg:GetFirst()
		while sc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetValue(d)
			sc:RegisterEffect(e1)
			sc=tg:GetNext()
		end
	end
end
function c100207016.indtg(e,c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsLocation(LOCATION_MZONE)
end
function c100207016.tglimit(e,re,c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsLocation(LOCATION_MZONE)
end
