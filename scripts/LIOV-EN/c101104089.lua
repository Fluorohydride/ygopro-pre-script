--War Rock Dignity
--Script By JSY1728 & mercury233
function c101104089.initial_effect(c)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101104089,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,101104089+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101104089.actcon)
	e1:SetTarget(c101104089.acttg)
	e1:SetOperation(c101104089.actop)
	c:RegisterEffect(e1)
end
function c101104089.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x15f)
end
function c101104089.actcon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainDisablable(ev) then return false end
	if not Duel.IsExistingMatchingCard(c101104089.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	return (re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsControler(1-tp))
		or (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
			and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and ep==1-tp)
end
function c101104089.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c101104089.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
