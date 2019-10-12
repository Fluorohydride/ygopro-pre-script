--ヘッド・ジャッジング

--Scripted by mallu11
function c101011080.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(101011080,0))
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e0:SetCondition(c101011080.condition)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101011080,1))
	e1:SetCategory(CATEGORY_COIN+CATEGORY_NEGATE+CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1,101011080)
	e1:SetCondition(c101011080.negcon)
	e1:SetTarget(c101011080.negtg)
	e1:SetOperation(c101011080.negop)
	c:RegisterEffect(e1)
	--negate
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e2)
end
c101011080.toss_coin=true
function c101011080.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE and Duel.GetCurrentPhase()~=PHASE_DAMAGE_CAL
end
function c101011080.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and re:IsActiveType(TYPE_MONSTER)
		and Duel.IsChainNegatable(ev) and re:GetHandler():IsControlerCanBeChanged()
end
function c101011080.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local p=re:GetHandlerPlayer()
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,p,1)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,eg,1,0,0)
end
function c101011080.negop(e,tp,eg,ep,ev,re,r,rp)
	local p=re:GetHandlerPlayer()
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_COIN)
	local coin=Duel.AnnounceCoin(p)
	local res=Duel.TossCoin(p,1)
	if coin==res and Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		if Duel.GetLocationCount(1-p,LOCATION_MZONE)<=0 then
			Duel.Destroy(eg,REASON_RULE)
		else
			Duel.GetControl(re:GetHandler(),1-p)
		end
	end
end
