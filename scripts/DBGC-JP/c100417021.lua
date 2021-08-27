--エクソシスター・パークス
--
--Script by IceBarrierTrishula
function c100417021.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100417021,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100417021+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCondition(c100417021.condition)
	e1:SetCost(c100417021.cost)
	e1:SetTarget(c100417021.target)
	e1:SetOperation(c100417021.operation)
	c:RegisterEffect(e1)
end
function c100417021.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c100417021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c100417021.thfilter(c)
	return c:IsSetCard(0x271) and not c:IsCode(100417021) and c:IsAbleToHand()
end
function c100417021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100417021.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100417021.spfilter(c,sc)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x271) and aux.IsCodeListed(sc,c:GetCode())
		and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c100417021.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c100417021.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	local res=false
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
		res=true
	end
	if res and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and tc:IsType(TYPE_MONSTER) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c100417021.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tc)
		and Duel.SelectYesNo(tp,aux.Stringid(100417021,1)) then
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
