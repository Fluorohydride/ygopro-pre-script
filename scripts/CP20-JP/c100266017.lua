--Afterglow
function c100266017.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,100266017+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100266017.target)
	e1:SetOperation(c100266017.operation)
	c:RegisterEffect(e1)
end
function c100266017.rmfilter(c)
	return c:IsCode(100266017) and c:IsAbleToRemove() and (c:IsFaceup() or not c:IsOnField())
end
function c100266017.tdfilter(c)
	return c:IsCode(100266017) and c:IsAbleToDeck() and c:IsFaceup()
end
function c100266017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c100266017.rmfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK,0,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
end
function c100266017.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c100266017.rmfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK,0,nil)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
		local tg=Duel.SelectMatchingCard(tp,c100266017.tdfilter,tp,LOCATION_REMOVED,0,1,1,nil)
		if tg:GetCount()>0 then
			Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DRAW)
	e1:SetCondition(c100266017.damcon)
	e1:SetOperation(c100266017.damop)
	e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
	Duel.RegisterEffect(e1,tp)
end
function c100266017.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==e:GetOwnerPlayer() and r==REASON_RULE
end
function c100266017.damop(e,tp,eg,ep,ev,re,r,rp)
	if ep~=e:GetOwnerPlayer() then return end
	local hg=eg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if hg:GetCount()==0 then return end
	Duel.ConfirmCards(1-ep,hg)
	local dg=hg:Filter(Card.IsCode,nil,100266017)
	if dg:GetCount()>0 then
		Duel.Damage(1-ep,4000,REASON_EFFECT)
	end
	Duel.ShuffleHand(ep)
end