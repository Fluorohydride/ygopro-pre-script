--春化精と花蕾
--
--Script by Trishula9
function c101109075.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101109075+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c101109075.target)
	e1:SetOperation(c101109075.activate)
	c:RegisterEffect(e1)
end
function c101109075.cfilter(c)
	return c:IsSummonLocation(LOCATION_GRAVE) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsFaceup()
end
function c101109075.thfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c101109075.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and c101109075.thfilter(chkc) end
	local g=Duel.GetMatchingGroup(c101109075.cfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return #g>0 and Duel.IsExistingTarget(c101109075.thfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local ct=g:GetClassCount(Card.GetCode)
	local sg=Duel.SelectTarget(tp,c101109075.thfilter,tp,0,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount()*2,0,0)
end
function c101109075.sfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsFaceup() and c:IsAbleToHand()
end
function c101109075.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	local ct=g:GetCount()
	local g2=Duel.GetMatchingGroup(c101109075.sfilter,tp,LOCATION_MZONE,0,nil)
	if g2:GetCount()<ct then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=g2:Select(tp,ct,ct,nil)
	if Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
