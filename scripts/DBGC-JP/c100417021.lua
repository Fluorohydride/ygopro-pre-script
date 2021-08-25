--エクソシスター・パークス
function c100417021.initial_effect(c)
	--to hand
	local e=Effect.CreateEffect(c)
	e:SetDescription(aux.Stringid(100417021,0))
	e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e:SetType(EFFECT_TYPE_ACTIVATE)
	e:SetCode(EVENT_FREE_CHAIN)
	e:SetCountLimit(1,100417021+EFFECT_COUNT_CODE_OATH)
	e:SetHintTiming(TIMING_MAIN_END)
	e:SetCondition(c100417021.thcon)
	e:SetCost(c100417021.thcost)
	e:SetTarget(c100417021.thtg)
	e:SetOperation(c100417021.thop)
	c:RegisterEffect(e)
end
function c100417021.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c100417021.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c100417021.thfilter(c)
	return c:IsSetCard(0x271) and not c:IsCode(100417021) and c:IsAbleToHand()
end
function c100417021.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100417021.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100417021.spfilter(c,code)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x271) and aux.IsCodeListed(c,code)
end
function c100417021.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c100417021.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT) then
		Duel.ConfirmCards(1-tp,tc)
		if tc:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c100417021.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tc:GetCode()) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(100417021,0)) then
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end