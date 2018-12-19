--D－タクティクス
--
--Script by mercury233
function c101008069.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101008069,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1,101008069)
	e2:SetTarget(c101008069.adtg)
	e2:SetOperation(c101008069.adop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101008069,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,101008069+100)
	e3:SetCondition(c101008069.rmcon)
	e3:SetTarget(c101008069.rmtg)
	e3:SetOperation(c101008069.rmop)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,101008069+200)
	e4:SetCondition(c101008069.thcon)
	e4:SetTarget(c101008069.thtg)
	e4:SetOperation(c101008069.thop)
	c:RegisterEffect(e4)
end
function c101008069.adfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x8)
end
function c101008069.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101008069.adfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c101008069.adop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101008069.adfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(400)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c101008069.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and (c:IsCode(76263644) or c:IsLevelAbove(8) and c:IsSetCard(0xc008))
end
function c101008069.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101008069.cfilter,1,nil,tp)
end
function c101008069.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c101008069.rmop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	local opt=0
	if g1:GetCount()>0 and g2:GetCount()>0 then
		opt=Duel.SelectOption(tp,aux.Stringid(101008069,2),aux.Stringid(101008069,3))
	elseif g1:GetCount()>0 then
		opt=0
	elseif g2:GetCount()>0 then
		opt=1
	else
		return
	end
	local sg=nil
	if opt==0 then
		sg=g1:RandomSelect(tp,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		sg=g2:Select(tp,1,1,nil)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
function c101008069.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_SZONE)
end
function c101008069.thfilter(c)
	return c:IsSetCard(0xc008) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c101008069.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101008069.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101008069.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101008069.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
