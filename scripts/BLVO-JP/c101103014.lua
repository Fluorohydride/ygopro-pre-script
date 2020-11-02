--S－Force グラビティーノ

--Scripted by mallu11
function c101103014.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101103014,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101103014)
	e1:SetTarget(c101103014.thtg)
	e1:SetOperation(c101103014.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--redirect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(c101103014.rmtg)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3)
end
function c101103014.thfilter(c)
	return c:IsSetCard(0x259) and not c:IsCode(101103014) and c:IsAbleToHand()
end
function c101103014.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101103014.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101103014.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101103014.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101103014.rmfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x259) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c101103014.rmtg(e,c)
	local cg=c:GetColumnGroup()
	return cg:IsExists(c101103014.rmfilter,1,nil,e:GetHandlerPlayer())
end
