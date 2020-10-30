--影依的炎核 虚梦狱
--"Lua By REIKAI 2404873791"
function c100270202.initial_effect(c)
   --flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100270202,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,100270202)
	e1:SetTarget(c100270202.target)
	e1:SetOperation(c100270202.operation)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100270202,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,100270202)
	e2:SetCondition(c100270202.tgcon)
	e2:SetTarget(c100270202.tgtg)
	e2:SetOperation(c100270202.tgop)
	c:RegisterEffect(e2)
end
function c100270202.refilter(c,tp)
	return c:IsFaceup() and c:IsAbleToRemove() and Duel.IsExistingMatchingCard(c100270202.tgfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetAttribute())
end
function c100270202.tgfilter(c,att)
	return c:IsAttribute(att) and c:IsAbleToGrave()
end
function c100270202.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c100270202.refilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c100270202.refilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c100270202.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local att=tc:GetAttribute()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c100270202.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil,att)
		local gc=g:GetFirst()
		if gc and Duel.SendtoGrave(gc,REASON_EFFECT)~=0 and gc:IsLocation(LOCATION_GRAVE) then
			Duel.Remove(tc,REASON_EFFECT)
		end
	end
end
function c100270202.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c100270202.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	local ct=g:GetSum(Card.GetAttribute)
	if chk==0 then return ct>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct and Duel.IsPlayerCanDiscardDeck(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
end
function c100270202.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	local ct=g:GetSum(Card.GetAttribute)
	if ct>0 then
		Duel.DiscardDeck(tp,ct,REASON_EFFECT)
	end
end
