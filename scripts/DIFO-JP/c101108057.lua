--烙印喪失
--
--Script by mercury233
function c101108057.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101108057+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101108057.target)
	e1:SetOperation(c101108057.activate)
	c:RegisterEffect(e1)
end
function c101108057.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION)
end
function c101108057.filter2(c)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsAbleToDeck()
end
function c101108057.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c101108057.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c101108057.filter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c101108057.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,c101108057.filter2,tp,0,LOCATION_MZONE,1,1,nil)
	g:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
end
function c101108057.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetOperation(c101108057.endop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c101108057.endop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,101108057)
	local p=Duel.GetTurnPlayer()
	c101108057.spop(e,p)
	p=1-p
	c101108057.spop(e,p)
end
function c101108057.spfilter(c,e,tp)
	return c:IsType(TYPE_FUSION) and aux.IsMaterialListCode(c,68468459)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c101108057.spop(e,p)
	if Duel.IsExistingMatchingCard(c101108057.spfilter,p,LOCATION_EXTRA,0,1,nil,e,p)
		and Duel.SelectYesNo(p,aux.Stringid(101108057,1)) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(p,c101108057.spfilter,p,LOCATION_EXTRA,0,1,1,nil,e,p)
		Duel.SpecialSummon(g,0,p,p,false,false,POS_FACEUP)
	end
end
