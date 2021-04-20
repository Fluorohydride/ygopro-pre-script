--グランドレミコード・ミューゼシア
--Grandoremichord Musesea
--Script by TheOnePharaoh
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
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101105048+100)
	e2:SetCondition(c101105048.thcon)
	e2:SetTarget(c101105048.thtg)
	e2:SetOperation(c101105048.thop)
	c:RegisterEffect(e2)
end
function c101105048.chkfilter(c,odevity)
	return c:GetCurrentScale()%2==odevity
end
function c101105048.thfilter(c,odevity)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:GetCurrentScale()%2==1-odevity
		and c:IsAbleToHand()
end
function c101105048.chkcon(g,tp,odevity)
	return g:IsExists(c101105048.chkfilter,1,nil,odevity) and Duel.IsExistingMatchingCard(c101105048.thfilter,tp,LOCATION_EXTRA,0,1,nil,odevity)
end
function c101105048.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,nil,TYPE_PENDULUM)
	if chk==0 then return c101105048.chkcon(g,tp,0) or c101105048.chkcon(g,tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c101105048.teop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,nil,TYPE_PENDULUM)
	local b1=c101105048.chkcon(g,tp,0)
	local b2=c101105048.chkcon(g,tp,1)
	local sg=Group.CreateGroup()
	if b1 and not b2 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101105048,3))
		sg=g:FilterSelect(tp,c101105048.chkfilter,1,1,nil,0)
	end
	if not b1 and b2 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101105048,3))
		sg=g:FilterSelect(tp,c101105048.chkfilter,1,1,nil,1)
	end
	if b1 and b2 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101105048,3))
		sg=g:Select(tp,1,1,nil)
	end
	local tc=sg:GetFirst()
	if tc and Duel.SendtoExtraP(tc,tp,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_EXTRA) then
		local odevity=tc:GetCurrentScale()%2
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c101105048.thfilter,tp,LOCATION_EXTRA,0,1,1,nil,odevity)
		if g2:GetCount()>0 then
			Duel.SendtoHand(g2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
		end
	end
end
function c101105048.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x162) and c:IsSummonPlayer(tp) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c101105048.tgfilter(c,tp,g)
	return g:IsContains(c) and Duel.IsExistingMatchingCard(c101105048.adfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c101105048.adfilter(c,scale)
	return c:IsSetCard(0x162) and c:IsType(TYPE_PENDULUM) and c:IsLevel(scale) and c:IsAbleToHand()
end
function c101105048.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101105048.cfilter,1,nil,tp)
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
