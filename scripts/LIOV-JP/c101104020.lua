--氷結界の浄玻璃
--Mirror Judge of the Ice Barrier
--LUA by Kohana Sonogami
function c101104020.initial_effect(c)
	--It Loses 500 LP for each time they pay/activate a card effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PAY_LPCOST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c101104020.llpcon)
	e1:SetOperation(c101104020.llpop)
	c:RegisterEffect(e1)
	--Target up to 2 "Ice Barrier" and opponent's card to the Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101104020,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101104020)
	e2:SetTarget(c101104020.tdtg)
	e2:SetOperation(c101104020.tdop)
	c:RegisterEffect(e2)
	--Change it to the Defense Position by banishing this card
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101104020,1))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,101104020+100)
	e3:SetCost(aux.bfgcost)
	e3:SetCondition(c101104020.poscon)
	e3:SetTarget(c101104020.postg)
	e3:SetOperation(c101104020.posop)
	c:RegisterEffect(e3)
end
function c101104020.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2f)
end
function c101104020.llpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101104020.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
		and ep==1-tp and re:IsActivated()
end
function c101104020.llpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,101104020)
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)-500)
end
function c101104020.tdfilter(c)
	return c:IsSetCard(0x2f) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c101104020.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c101104020.tdfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c101104020.tdfilter,tp,LOCATION_GRAVE,0,1,2,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,2,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,g1:GetCount(),0,0)
end
function c101104020.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c101104020.poscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101104020.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101104020.posfilter(c)
	return c:IsAttackPos() and c:IsCanChangePosition()
end
function c101104020.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101104020.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101104020.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c101104020.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c101104020.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsAttackPos() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
	end
end
