--Grandoremichord Musesea
function c101105048.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_PENDULUM),2,2)
	--to extra and hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101105048,0))
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101105048)
	e1:SetTarget(c101105048.tetg)
	e1:SetOperation(c101105048.teop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101105048,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101105048)
	e2:SetCondition(c101105048.thcon)
	e2:SetTarget(c101105048.thtg)
	e2:SetOperation(c101105048.thop)
	c:RegisterEffect(e2)
end
function c101105048.tefilter(c)
	return c:GetOriginalType()&TYPE_PENDULUM~=0
end
function c101105048.chkfilter(c,odevity)
	return c:GetCurrentScale()%2==odevity
end
function c101105048.thfilter(c,e,tp,odevity)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:GetCurrentScale()%2==odevity
		and c:IsAbleToHand()
end
function c101105048.chkcon(g,e,tp,odevity)
	return g:IsExists(c101105048.chkfilter,1,nil,odevity) and Duel.IsExistingMatchingCard(c101105048.thfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,odevity)
end

function c101105048.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c101105048.tefilter,tp,LOCATION_HAND,0,nil)
	if chk==0 then return g:IsExists(c101105048.chkcon,1,nil,1) or g:IsExists(c101105048.chkcon,1,nil,0) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)

end
function c101105048.teop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101105048,3))
	local g=Duel.SelectMatchingCard(tp,c101105048.tefilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,tp,REASON_EFFECT)
		local odevity=g:GetFirst():GetCurrentScale()%2
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c101105048.thfilter,tp,LOCATION_EXTRA,0,1,1,nil,odevity)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
unction c101105048.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x163) and c:IsSummonPlayer(tp) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c101105048.tgfilter(c,tp,g)
	return g:IsContains(c) and Duel.IsExistingMatchingCard(c101105048.adfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c101105048.adfilter(c,scale)
	return c:IsSetCard(0x163) and c:IsType(TYPE_MONSTER) and not c:GetLevel()==scale and c:IsAbleToHand()
end
function c101105048.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and eg:IsExists(c101105048.cfilter,1,nil,tp)
end
function c101105048.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=eg:Filter(c101105048.cfilter,nil,tp)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101105048.tgfilter(chkc,tp,g) end
	if chk==0 then return Duel.IsExistingTarget(c101105048.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,g) end
	if g:GetCount()==1 then
		Duel.SetTargetCard(g)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,c101105048.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101105048.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local scale=tc:GetCurrentScale()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c101105048.adfilter,tp,LOCATION_DECK,0,1,1,nil,scale)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
