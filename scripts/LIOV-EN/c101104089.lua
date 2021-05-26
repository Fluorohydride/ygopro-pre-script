--War Rock Dignity
--Script By JSY1728
function c101104089.initial_effect(c)
	--Negate : Monster Effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101104089,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,101104089+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101104089.actcon1)
	e1:SetTarget(c101104089.acttg1)
	e1:SetOperation(c101104089.actop1)
	c:RegisterEffect(e1)
	--Negate : Your Opponent's Card
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101104089,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,101104089+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c101104089.actcon2)
	e2:SetTarget(c101104089.acttg2)
	e2:SetOperation(c101104089.actop2)
	c:RegisterEffect(e2)
end
function c101104089.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x15f)
end
function c101104089.actcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED)
		and not Duel.IsExistingMatchingCard(c101104089.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
end
function c101104089.acttg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c101104089.actop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c101104089.actcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) and not (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
		and not Duel.IsExistingMatchingCard(c101104089.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainDisablable(ev)
end
function c101104089.acttg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c101104089.actop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end