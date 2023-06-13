--新世廻
--
--Script by Trishula9
function c101202072.initial_effect(c)
	aux.AddCodeList(c,56099748)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101202072,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101202072)
	e1:SetCondition(c101202072.condition)
	e1:SetTarget(c101202072.target)
	e1:SetOperation(c101202072.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101202072,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,101202072+100)
	e2:SetCondition(c101202072.thcon)
	e2:SetTarget(c101202072.thtg)
	e2:SetOperation(c101202072.thop)
	c:RegisterEffect(e2)
end
function c101202072.cfilter(c)
	return c:IsCode(56099748) and c:IsFaceup()
end
function c101202072.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101202072.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c101202072.filter(c)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup() and c:IsAbleToDeck()
end
function c101202072.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101202072.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101202072.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c101202072.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c101202072.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetCondition(c101202072.srcon)
		e1:SetOperation(c101202072.srop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
	end
end
function c101202072.srfilter(c,race,lv)
	return c:IsType(TYPE_MONSTER) and not c:IsRace(race) and c:IsLevelBelow(lv) and c:IsAbleToHand()
end
function c101202072.srcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc then return false end
	local op=tc:GetOwner()
	local race=tc:GetRace()
	local lv=tc:GetLevel()|tc:GetRank()|tc:GetLink()
	return Duel.IsExistingMatchingCard(c101202072.srfilter,op,LOCATION_DECK,0,1,nil,race,lv)
end
function c101202072.srop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not tc then return end
	Duel.Hint(HINT_CARD,0,101202072)
	local op=tc:GetOwner()
	local race=tc:GetRace()
	local lv=tc:GetLevel()|tc:GetRank()|tc:GetLink()
	if Duel.SelectYesNo(op,aux.Stringid(101202072,2)) then
		Duel.Hint(HINT_SELECTMSG,op,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(op,c101202072.srfilter,op,LOCATION_DECK,0,1,1,nil,race,lv)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-op,g)
		end
	end
end
function c101202072.thfilter(c,tp)
	return c:IsSetCard(0x29a) and c:IsFaceup()
end
function c101202072.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101202072.thfilter,1,nil,tp)
end
function c101202072.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c101202072.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end