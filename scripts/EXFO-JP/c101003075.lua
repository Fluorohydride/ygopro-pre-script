--デーモンの呼び声
--Call of the Archfiend
--Scripted by Eerie Code
function c101003075.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c101003075.target)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35125879,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c101003075.cost)
	e2:SetTarget(c101003075.sptg)
	e2:SetOperation(c101003075.spop)
	c:RegisterEffect(e2)
end
function c101003075.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,101003075)==0 end
	Duel.RegisterFlagEffect(tp,101003075,RESET_PHASE+PHASE_END,0,1)
end
function c101003075.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c101003075.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	if chk==0 then return true end
	local b1=c101003075.cost(e,tp,eg,ep,ev,re,r,rp,0)
		and c101003075.sptg(e,tp,eg,ep,ev,re,r,rp,0)
	if b1 and Duel.SelectYesNo(tp,94) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(c101003075.spop)
		c101003075.cost(e,tp,eg,ep,ev,re,r,rp,1)
		c101003075.sptg(e,tp,eg,ep,ev,re,r,rp,1)		
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c101003075.spfilter(c,e,tp)
	return c:IsRace(RACE_FIEND) and c:IsLevelAbove(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101003075.cfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsDiscardable(REASON_EFFECT)
end
function c101003075.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101003075.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101003075.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c101003075.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101003075.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
end
function c101003075.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or not tc:IsRelateToEffect(e) then return end
	if Duel.DiscardHand(tp,c101003075.cfilter,1,1,REASON_EFFECT,nil)~=0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
