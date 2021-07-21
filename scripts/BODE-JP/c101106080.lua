--洗衣龙女困境
function c101106080.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3701074,0))
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c101106080.distg)
	e2:SetOperation(c101106080.disop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--to deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101106080,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,101106080)
	e4:SetCondition(c101106080.thcon)
	e4:SetTarget(c101106080.thtg)
	e4:SetOperation(c101106080.thop)
	c:RegisterEffect(e4)
end
function c101106080.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return rp==tp end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end
function c101106080.disop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.DiscardDeck(p,d,REASON_EFFECT)
end
function c101106080.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK) and  e:GetHandler():IsReason(REASON_EFFECT)
end
function c101106080.thfilter(c,id)
	return c:GetTurnID()==id and not (c:IsReason(REASON_RETURN) or c:IsCode(101106080)) and c:IsAbleToHand()
end
function c101106080.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tid=Duel.GetTurnCount()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101106080.thfilter(chkc,tid) end
	if chk==0 then return Duel.IsExistingTarget(c101106080.thfilter,tp,LOCATION_GRAVE,0,1,nil,tid) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101106080.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,tid)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101106080.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc then return end
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(c101106080.actlimit)
		e1:SetLabel(tc:GetCode())
		if Duel.GetTurnPlayer()==tp then
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
		end
		Duel.RegisterEffect(e1,tp)
	end
end
function c101106080.actlimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
