--八雷天神
--
--Script by Trishula9
function c100200210.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c100200210.spcon)
	e1:SetOperation(c100200210.spop)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,100200210)
	e2:SetTarget(c100200210.tdtg)
	e2:SetOperation(c100200210.tdop)
	c:RegisterEffect(e2)
end
function c100200210.spfilter(c)
	return (c:IsLevel(8) or c:IsRank(8)) and c:IsAbleToRemoveAsCost()
end
function c100200210.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100200210.spfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c100200210.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c100200210.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c100200210.tdfilter(c)
	return ((c:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_SYNCHRO) and c:IsLevel(8))
		or (c:IsType(TYPE_XYZ) and c:IsRank(8))) and c:IsAbleToDeck()
end
function c100200210.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c100200210.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100200210.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c100200210.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c100200210.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and
		((tc:IsType(TYPE_RITUAL) and tc:IsLocation(LOCATION_DECK)) or
		(tc:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) and tc:IsLocation(LOCATION_EXTRA))) then
		if tc:IsType(TYPE_RITUAL+TYPE_FUSION) then
			Duel.BreakEffect()
			Duel.ShuffleDeck(tp)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
		if tc:IsType(TYPE_SYNCHRO+TYPE_XYZ) then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(1000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			e:GetHandler():RegisterEffect(e1)
		end
	end
end
