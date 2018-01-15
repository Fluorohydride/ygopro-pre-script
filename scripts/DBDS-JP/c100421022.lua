--空牙団の叡智 ウィズ　
--Wiz, Sage of the Skyfang Brigade
function c100421022.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100421022,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,100421022)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e1:SetTarget(c100421022.rectg)
	e1:SetOperation(c100421022.recop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100421022,0))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,100421022+100)
	e2:SetCost(c100421022.cost)
	e2:SetCondition(c100421022.discon)
	e2:SetTarget(c100421022.distg)
	e2:SetOperation(c100421022.disop)
	c:RegisterEffect(e2)
end
function c100421022.recfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x214) and c:IsType(TYPE_MONSTER)
end
function c100421022.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100421022.recfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c100421020.damfilter,tp,LOCATION_MZONE,0,nil)
	local val=g:GetClassCount(Card.GetCode)*500
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,val)
end
function c100421022.recop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100421020.damfilter,tp,LOCATION_MZONE,0,nil)
	local val=g:GetClassCount(Card.GetCode)*500
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,val,REASON_EFFECT)
end


function c100421022.cfilter(c)
	return c:IsSetCard(0x214) and c:IsDiscardable()
end
function c100421022.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100421022.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c100421022.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c100421022.discon(e,tp,eg,ep,ev,re,r,rp,chk)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp~=tp and Duel.IsChainNegatable(ev)
end
function c100421022.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c100421022.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
