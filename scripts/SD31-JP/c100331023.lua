--星霜のペンデュラムグラフ
--Pendulumgraph of Ages
--Scripted by Eerie Code
function c100331023.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_SPELLCASTER))
	e2:SetValue(c100331023.evalue)
	c:RegisterEffect(e2)
	--Search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,100331023)
	e3:SetCondition(c100331023.thcon)
	e3:SetTarget(c100331023.thtg)
	e3:SetOperation(c100331023.thop)
	c:RegisterEffect(e3)
end
function c100331023.evalue(e,re,rp)
	return re:IsActiveType(TYPE_SPELL) and rp~=e:GetHandlerPlayer()
end
function c100331023.thcfilter(c,tp)
	local pl=c:GetPreviousLocation()
	local ps=c:GetPreviousSequence()
	return c:IsType(TYPE_PENDULUM) and c:IsPreviousSetCard(0x98)
		and c:GetPreviousControler()==tp and c:IsPreviousPosition(POS_FACEUP)
		and (pl==LOCATION_MZONE or (pl==LOCATION_SZONE and (ps==6 or ps==7)))
end
function c100331023.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c100331023.thcfilter,1,nil,tp)
end
function c100331023.thfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x98) and c:IsAbleToHand()
end
function c100331023.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100331023.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100331023.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100331023.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
