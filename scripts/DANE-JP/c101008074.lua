--オルフェゴール・クリマクス
--
--Scripted by Djeeta
function c101008074.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,101008074+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101008074.condition)
	e1:SetTarget(c101008074.target)
	e1:SetOperation(c101008074.activate)
	c:RegisterEffect(e1) 
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,101008074)
	e2:SetCost(c101008074.thcost)
	e2:SetTarget(c101008074.thtg)
	e2:SetOperation(c101008074.thop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(101008074,ACTIVITY_SPSUMMON,c101008074.counterfilter)
end
function c101008074.counterfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c101008074.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x11b) and c:IsType(TYPE_LINK)
end
function c101008074.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101008074.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c101008074.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c101008074.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
	Duel.RegisterFlagEffect(tp,101008074,RESET_PHASE+PHASE_END,0,1)
end
function c101008074.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(101008074,tp,ACTIVITY_SPSUMMON)==0
		and Duel.GetFlagEffect(tp,101008074)==0
		and aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101008074.splimit)
	Duel.RegisterEffect(e1,tp)
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,1)
end
function c101008074.splimit(e,c)
	return not (c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_DARK))
end
function c101008074.thfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
		and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end
function c101008074.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101008074.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c101008074.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101008074.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
