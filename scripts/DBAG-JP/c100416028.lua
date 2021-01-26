--ベアルクティ－ミクタナス

--Scripted by mallu11
function c100416028.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100416028,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100416028)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCondition(c100416028.spcon)
	e1:SetCost(c100416028.spcost)
	e1:SetTarget(c100416028.sptg)
	e1:SetOperation(c100416028.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100416028,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,100416028+100)
	e2:SetTarget(c100416028.thtg)
	e2:SetOperation(c100416028.thop)
	c:RegisterEffect(e2)
end
function c100416028.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c100416028.rfilter(c,tp)
	return c:IsLevelAbove(7) and (c:IsControler(tp) and c:IsLocation(LOCATION_HAND) or c:IsFaceup() and c:IsControler(1-tp))
end
function c100416028.excostfilter(c,tp)
	return c:IsAbleToRemove() and c:IsHasEffect(100416038,tp)
end
function c100416028.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetReleaseGroup(tp,true):Filter(c100416028.rfilter,e:GetHandler(),tp)
	local g2=Duel.GetMatchingGroup(c100416028.excostfilter,tp,LOCATION_GRAVE,0,nil,tp)
	g1:Merge(g2)
	if chk==0 then return g1:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100416028,2))
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
function c100416028.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100416028.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c100416028.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c100416028.splimit(e,c)
	return c:IsLevel(0)
end
function c100416028.thfilter(c)
	return c:IsSetCard(0x261) and c:IsType(TYPE_MONSTER) and not c:IsCode(100416028) and c:IsAbleToHand()
end
function c100416028.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c100416028.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100416028.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c100416028.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c100416028.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
