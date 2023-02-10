--寝姫の甘い夢
--Script by 奥克斯
function c101112060.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101112060,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101112060+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101112060.target)
	e1:SetOperation(c101112060.activate)
	c:RegisterEffect(e1)
	--Effect 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112060,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c101112060.mvcost)
	e2:SetTarget(c101112060.mvtg)
	e2:SetOperation(c101112060.mvop)
	c:RegisterEffect(e2)
end
function c101112060.filter(c)
	return c:IsSetCard(0x292) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c101112060.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101112060.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101112060.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101112060.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	if g:GetFirst():IsLocation(LOCATION_HAND)
		and Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsCode),tp,LOCATION_EXTRA,0,1,nil,101112015) then
		Duel.BreakEffect()
		Duel.Hint(HINT_CARD,0,101112015)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetCondition(c101112060.sumcon)
		e1:SetOperation(c101112060.sumsuc)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(e2,tp)
	end
end
function c101112060.sumfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x292)
end
function c101112060.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101112060.sumfilter,1,nil)
end
function c101112060.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c101112060.efun)
end
function c101112060.efun(e,ep,tp)
	return ep==tp
end
function c101112060.mvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_COST)
end
function c101112060.mvfilter(c)
	return c:IsFaceup() and c:IsCode(101112015) and c:IsType(TYPE_PENDULUM) and c:IsAbleToExtra()
end
function c101112060.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101112060.mvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101112060.mvfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101112060.mvfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,1,0,0)
end
function c101112060.mvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoExtraP(tc,nil,REASON_EFFECT)
	end
end
