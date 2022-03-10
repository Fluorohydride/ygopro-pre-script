--悪魔嬢ロリス
--
--Script by Trishula9
function c100200216.initial_effect(c)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,100200216)
	e1:SetTarget(c100200216.tdtg)
	e1:SetOperation(c100200216.tdop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,100200216+100)
	e2:SetCondition(c100200216.stcon1)
	e2:SetTarget(c100200216.sttg)
	e2:SetOperation(c100200216.stop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c100200216.stcon2)
	c:RegisterEffect(e3)
end
function c100200216.tdfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:GetType()==TYPE_TRAP and c:IsAbleToDeck()
end
function c100200216.fselect(sg)
	return sg:GetCount()==3 or sg:GetCount()==6
end
function c100200216.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c100200216.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c100200216.tdfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and #g>=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,c100200216.fselect,false,3,6)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,sg:GetCount()//3)
end
function c100200216.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
		if ct==0 then return end
		Duel.SortDecktop(tp,tp,ct)
		for i=1,ct do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),1)
		end
		Duel.BreakEffect()
		Duel.Draw(tp,ct//3,REASON_EFFECT)
	end
end
function c100200216.cfilter1(c)
	return (c:IsType(TYPE_MONSTER) and not c:IsPreviousLocation(LOCATION_SZONE)) or c:IsPreviousLocation(LOCATION_MZONE)
end
function c100200216.stcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100200216.cfilter1,1,nil) and not eg:IsContains(e:GetHandler())
end
function c100200216.cfilter2(c,tp)
	return c:GetType()==TYPE_TRAP and c:GetControler()==tp and c:GetReason()&REASON_EFFECT>0 and c:GetReasonPlayer()==1-tp
end
function c100200216.stcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100200216.cfilter2,1,nil,tp)
end
function c100200216.stfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:GetType()==TYPE_TRAP and c:IsSSetable()
end
function c100200216.sttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c100200216.stfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100200216.stfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c100200216.stfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c100200216.stop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SSet(tp,tc)
	end
end