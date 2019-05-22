--ファイアウォール・ドラゴン・ダークフルード
--
--Scripted by 龙骑
function c101010037.initial_effect(c)
	c:EnableCounterPermit(0x152)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101010037,1))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101010037.ctcon)
	e1:SetOperation(c101010037.ctop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101010037.atkcon)
	e2:SetValue(c101010037.atkval)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101010037,1))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c101010037.discon)
	e3:SetCost(c101010037.discost)
	e3:SetTarget(c101010037.distg)
	e3:SetOperation(c101010037.disop)
	c:RegisterEffect(e3)
end
function c101010037.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and Duel.IsExistingMatchingCard(c101010037.cfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c101010037.cfilter(c)
	return c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
end
function c101010037.cfilter2(c,type)
	return c:IsRace(RACE_CYBERSE) and c:IsType(type)
end
function c101010037.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local ct=0
	for i,type in ipairs({TYPE_FUSION,TYPE_RITUAL,TYPE_SYNCHRO,TYPE_XYZ}) do
		if Duel.IsExistingMatchingCard(c101010037.cfilter2,0,LOCATION_GRAVE,0,1,nil,type) then
			ct=ct+1
		end
	end
	if ct>0 then
		c:AddCounter(0x152,ct)
	end
end
function c101010037.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c101010037.atkval(e,c)
	return c:GetCounter(0x152)*2500
end
function c101010037.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_MONSTER)
end
function c101010037.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x152,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x152,1,REASON_COST)
end
function c101010037.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if Duel.GetAttacker()==e:GetHandler() then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c101010037.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev)~=0 and e:GetLabel()>0 then
		if c:IsRelateToEffect(e) and c:IsChainAttackable() then
			Duel.ChainAttack()
		end
	end
end
