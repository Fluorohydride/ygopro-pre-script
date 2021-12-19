--外法の騎士
function c101108023.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDesciption(aux.Stringid(101108023,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101108023)
	e1:SetCondition(c101108023.spcon)
	e1:SetTarget(c101108023.sptg)
	e1:SetOperation(c101108023.spop)
	c:RegisterEffect(e1)
	--Return to Hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101108023,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,101108023)
	e2:SetCondition(c101108023.rhcon)
	e2:SetTarget(c101108023.rhtg)
	e2:SetOperation(c101108023.rhop)
	c:RegisterEffect(e2)
end
function c101108023.spcfilter(c)
	return not c:IsType(TYPE_MONSTER) or c:IsCode(3285552)
end
function c101108023.spcon(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) then return false end
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 or Duel.IsExistingMatchingCard(c101108023.spcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101108023.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101108023.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101108023.rhcfilter(c)
	return c:IsCode(3285552)
end
function c101108023.rhcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101108023.rhcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101108023.rhtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,aux.TRUE,0,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c101108023.rhop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHadnler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 and Duel.GetControl(c,1-tp) then
		Duel.SendtoHand(tg,REASON_EFFECT)
	end
end
