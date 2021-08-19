--代行者の近衛 ムーン
--
--scripted by XyLeN
function c100312052.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_FAIRY),2,2)
	aux.AddCodeList(c,56433456)
	c:EnableReviveLimit()
	--to grave or to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100312052,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,100312052)
	e1:SetCondition(c100312052.condition)
	e1:SetTarget(c100312052.target)
	e1:SetOperation(c100312052.operation)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100312052,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100312052+100)
	e2:SetCost(c100312052.descost)
	e2:SetTarget(c100312052.destg)
	e2:SetOperation(c100312052.desop)
	c:RegisterEffect(e2)
end
function c100312052.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c100312052.tgfilter(c)
	return (c:IsCode(56433456) or aux.IsCodeListed(c,56433456)) and c:IsAbleToGrave()
end
function c100312052.thfilter(c)
	return c:IsCode(91188343) and c:IsAbleToHand()
end
function c100312052.cfilter(c)
	return c:IsCode(56433456) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c100312052.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b=Duel.IsExistingMatchingCard(c100312052.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c100312052.tgfilter,tp,LOCATION_DECK,0,1,nil)
		or b and Duel.IsExistingMatchingCard(c100312052.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100312052.operation(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.IsExistingMatchingCard(c100312052.tgfilter,tp,LOCATION_DECK,0,1,nil)
	local b=Duel.IsExistingMatchingCard(c100312052.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil)
	if b and Duel.IsExistingMatchingCard(c100312052.thfilter,tp,LOCATION_DECK,0,1,nil) and (not a or Duel.SelectYesNo(tp,aux.Stringid(100312052,2))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c100312052.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c100312052.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function c100312052.costfilter(c)
	return c:IsRace(RACE_FAIRY)
end
function c100312052.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c100312052.costfilter,1,nil) end
	local rg=Duel.SelectReleaseGroup(tp,c100312052.costfilter,1,1,nil)
	Duel.Release(rg,REASON_COST)
end
function c100312052.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100312052.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
