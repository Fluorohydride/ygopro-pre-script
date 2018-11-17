--PSYフレームロード・Λ

--Script by nekrozar
function c100235086.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.NOT(aux.FilterBoolFunction(Card.IsLinkType,TYPE_TOKEN)),2,2)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(100235086)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100235086,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,100235086)
	e2:SetCondition(c100235086.regcon)
	e2:SetTarget(c100235086.regtg)
	e2:SetOperation(c100235086.regop)
	c:RegisterEffect(e2)
end
function c100235086.cfilter(c,tp)
	return c:IsFaceup() and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_MZONE)
		and bit.band(c:GetPreviousRaceOnField(),RACE_PSYCHO)~=0 and c:GetPreviousControler()==tp
end
function c100235086.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100235086.cfilter,1,nil,tp)
end
function c100235086.regtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0xc1) end
end
function c100235086.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c100235086.thcon)
	e1:SetOperation(c100235086.thop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c100235086.thfilter(c)
	return c:IsSetCard(0xc1) and c:IsAbleToHand()
end
function c100235086.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100235086.thfilter,tp,LOCATION_DECK,0,1,nil)
end
function c100235086.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,100235086)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100235086.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
