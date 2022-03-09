--白銀の城の火吹炉
--
--Script by Trishula9
function c100418019.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,100418019)
	e1:SetCost(c100418019.stcost)
	e1:SetTarget(c100418019.sttg)
	e1:SetOperation(c100418019.stop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,100418019+100)
	e2:SetCondition(c100418019.spcon)
	e2:SetTarget(c100418019.sptg)
	e2:SetOperation(c100418019.spop)
	c:RegisterEffect(e2)
end
function c100418019.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c) end
	Duel.SendtoGrave(c,REASON_COST)
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c100418019.stfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x280) and c:IsSSetable()
end
function c100418019.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100418019.stfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
end
function c100418019.stop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c100418019.stfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end
function c100418019.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetReasonEffect():GetHandler():GetType()==TYPE_TRAP
		and c:GetReasonEffect():IsActiveType(TYPE_TRAP) and c:GetReasonEffect():GetHandlerPlayer()==tp
end
function c100418019.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100418019.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c100418019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100418019.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e,0,tp,false,false,POS_FACEUP)
	end
end