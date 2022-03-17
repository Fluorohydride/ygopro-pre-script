--ラビュリンス・セッティング
--
--Script by Trishula9
function c100418022.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,100418022+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100418022.target)
	e1:SetOperation(c100418022.activate)
	c:RegisterEffect(e1)
end
function c100418022.tdfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsType(TYPE_SPELL+TYPE_TRAP)
		and c:IsSetCard(0x280) and not c:IsCode(100418022) and c:IsAbleToDeck()
end
function c100418022.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c100418022.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100418022.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c100418022.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
end
function c100418022.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local ct=tg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
		local dem=Duel.GetMatchingGroupCount(c100418022.demfilter,tp,LOCATION_MZONE,0,nil)
		local sg=Duel.GetMatchingGroup(c100418022.stfilter,tp,LOCATION_DECK,0,nil)
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if ct>0 and dem>0 and sg:GetCount()>=ct and ft>=ct and Duel.SelectYesNo(tp,aux.Stringid(100418022,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local stg=sg:SelectSubGroup(tp,aux.dncheck,false,ct,ct)
			Duel.SSet(tp,stg)
		end
	end
end
function c100418022.demfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsFaceup()
end
function c100418022.stfilter(c)
	return c:GetType()==TYPE_TRAP and not c:IsSetCard(0x280) and c:IsSSetable()
end
