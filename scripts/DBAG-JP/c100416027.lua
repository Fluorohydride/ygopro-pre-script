--ベアルクティ－ミクポーラ
--Bearcti - Micpola
--Scripted by Kohana Sonogami
function c100416027.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100416027,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,100416027)
	e1:SetCondition(c100416027.spcon)
	e1:SetCost(c100416027.spcost)
	e1:SetTarget(c100416027.sptg)
	e1:SetOperation(c100416027.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100416027,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,100416027+100)
	e2:SetTarget(c100416027.thtg)
	e2:SetOperation(c100416027.thop)
	c:RegisterEffect(e2)
end
function c100416027.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c100416027.rfilter(c,tp)
	return c:IsLevelAbove(7) and (c:IsControler(tp) and c:IsLocation(LOCATION_HAND) or c:IsFaceup() and c:IsControler(1-tp))
end
function c100416027.excostfilter(c,tp)
	return c:IsAbleToRemove() and c:IsHasEffect(100416038,tp)
end
function c100416027.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetReleaseGroup(tp,true):Filter(c100416027.rfilter,e:GetHandler(),tp)
	local g2=Duel.GetMatchingGroup(c100416027.excostfilter,tp,LOCATION_GRAVE,0,nil,tp)
	g1:Merge(g2)
	if chk==0 then return g1:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	tc=g1:Select(tp,1,1,nil):GetFirst()
	if tc:IsLocation(LOCATION_GRAVE) then
		local te=tc:IsHasEffect(100416038,tp)
		if te then
			te:UseCountLimit(tp)
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
		end
	else
		Duel.Release(tc,REASON_COST)
	end
end
function c100416027.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100416027.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c100416027.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c100416027.splimit(e,c)
	return c:IsLevel(0)
end
function c100416027.thfilter(c)
	return c:IsLevelBelow(0x261) and c:IsType(TYPE_MONSTER) and not c:IsCode(100416027) and c:IsAbleToHand()
end
function c100416027.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100416027.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100416027.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100416027.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
