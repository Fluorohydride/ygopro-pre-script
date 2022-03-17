--白銀の城の竜飾灯
--
--Script by Trishula9
function c100418018.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100418018,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,100418018)
	e1:SetCost(c100418018.stcost)
	e1:SetTarget(c100418018.sttg)
	e1:SetOperation(c100418018.stop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100418018,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,100418018+100)
	e2:SetCondition(c100418018.thcon)
	e2:SetTarget(c100418018.thtg)
	e2:SetOperation(c100418018.thop)
	c:RegisterEffect(e2)
end
function c100418018.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c) end
	Duel.SendtoGrave(c,REASON_COST)
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c100418018.stfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x280) and c:IsSSetable()
end
function c100418018.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100418018.stfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
end
function c100418018.stop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c100418018.stfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end
function c100418018.cfilter(c,tp,re,r,rp)
	return bit.band(c:GetPreviousTypeOnField(),TYPE_MONSTER)~=0 and bit.band(r,REASON_EFFECT)~=0 and rp==tp
		and re:GetHandler():GetType()==TYPE_TRAP and re:IsActiveType(TYPE_TRAP)
end
function c100418018.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100418018.cfilter,1,nil,tp,re,r,rp) and not eg:IsContains(e:GetHandler())
end
function c100418018.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c100418018.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
