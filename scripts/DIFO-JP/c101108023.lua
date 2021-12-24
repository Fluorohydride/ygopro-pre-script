--外法の騎士
--
--Script by JSY1728
function c101108023.initial_effect(c)
	aux.AddCodeList(c,3285552)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101108023,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101108023)
	e1:SetCondition(c101108023.spcon)
	e1:SetTarget(c101108023.sptg)
	e1:SetOperation(c101108023.spop)
	c:RegisterEffect(e1)
	--Return to Hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101108023,1))
	e2:SetCategory(CATEGORY_CONTROL+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,101108023+100)
	e2:SetCondition(c101108023.rhcon)
	e2:SetTarget(c101108023.rhtg)
	e2:SetOperation(c101108023.rhop)
	c:RegisterEffect(e2)
end
function c101108023.cfilter(c)
	return c:IsCode(3285552) and c:IsFaceup()
end
function c101108023.spcon(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) then return false end
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		or Duel.IsExistingMatchingCard(c101108023.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
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
function c101108023.rhcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101108023.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101108023.rhtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c101108023.rhop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if c:IsRelateToEffect(e) and Duel.GetControl(c,1-tp) and tg:GetCount()>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
