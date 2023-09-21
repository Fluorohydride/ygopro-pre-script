--ホルスの先導-ハーピ
--Script by Ruby
function c101202013.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,101202013+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101202013.sprcon)
	c:RegisterEffect(e1)
	--Leave Field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101202013,1))
	e2:SetCategory(CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101202113)
	e2:SetCondition(c101202013.descon)
	e2:SetOperation(c101202013.desop)
	e2:SetTarget(c101202013.destg)
	c:RegisterEffect(e2)
end
function c101202013.sprfilter(c)
	return c:IsFaceup() and c:IsCode(101202058)
end
function c101202013.sprcon(e,c)
	if c==nil then return true end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101202013.sprfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c101202013.cfilter(c,tp)
	return c:IsPreviousControler(tp)
		and c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)
end
function c101202013.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101202013.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c101202013.tgfilter(c,tp)
	return c:IsAbleToDeck() or c:IsAbleToHand()
end
function c101202013.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c101202013.tgfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c101202013.tgfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,2,2,nil)
	if not g:FilterCount(Card.IsAbleToHand,nil,e)==g:GetCount() then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	elseif not g:FilterCount(Card.IsAbleToDeck,nil,e)==g:GetCount() then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,2,0,0)
end
function c101202013.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()==2 and tg:FilterCount(Card.IsAbleToHand,nil,e)==tg:GetCount()
		and (not tg:FilterCount(Card.IsAbleToDeck,nil,e)==tg:GetCount() or Duel.SelectYesNo(tp,aux.Stringid(101202013,2))) then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	else
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
