--迷犬 小玛栗
function c101106035.initial_effect(c)
	--effect 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101106035,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(101106035)
	e1:SetTarget(c101106035.target)
	e1:SetOperation(c101106035.operation)
	c:RegisterEffect(e1)
end
function c101106035.thfilter(c)
	return c:IsCode(11548522) and c:IsAbleToHand()
end
function c101106035.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=e:GetHandler():IsAbleToDeck() 
	local b2=Duel.IsExistingMatchingCard(c101106035.thfilter,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsAbleToDeck() 
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(101106035,1),aux.Stringid(101106035,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(101106035,1))
	else op=Duel.SelectOption(tp,aux.Stringid(101106035,2))+1 end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	else
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c101106035.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then
		Duel.SendtoDeck(c,nil,1,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c101106035.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleDeck(tp)
			Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
		end
	end
end





