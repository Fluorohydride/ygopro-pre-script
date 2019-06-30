--スレイブパンサー
--
--Script by DJ
function c101010046.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c101010046.lcheck)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101010046,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,101010046)
	e1:SetCondition(c101010046.thcon)
	e1:SetTarget(c101010046.thtg)
	e1:SetOperation(c101010046.thop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101010046,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101010046+100)
	e2:SetTarget(c101010046.sptg)
	e2:SetOperation(c101010046.spop)
	c:RegisterEffect(e2)
end
function c101010046.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x19)
end
function c101010046.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c101010046.thfilter(c)
	return c:IsSetCard(0x19) and c:IsAbleToHand()
end
function c101010046.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010046.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101010046.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101010046.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101010046.tdfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x19) and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c101010046.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c101010046.spfilter(c,e,tp,tc)
	return c:IsSetCard(0x19) and not c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
		and c:IsCanBeSpecialSummoned(e,135,tp,false,false)
end
function c101010046.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101010046.tdfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101010046.tdfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c101010046.tdfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101010046.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c101010046.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,135,tp,tp,false,false,POS_FACEUP)
		end
	end
end
