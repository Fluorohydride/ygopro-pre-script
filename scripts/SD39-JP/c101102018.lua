--U.A. Libero Spiker
--Scripted by Sock#3222
function c101102018.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101102018)
	e1:SetCondition(c101102018.spcon)
	e1:SetOperation(c101102018.spop)
	c:RegisterEffect(e1)
	--special summon from deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(44656450,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101102018+100)
	e2:SetCondition(c101102018.spcon2)
	e2:SetTarget(c101102018.sptg2)
	e2:SetOperation(c101102018.spop2)
	c:RegisterEffect(e2)
end
function c101102018.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end

function c101102018.spfilter1(c)
	return c:IsSetCard(0xb2) and c:IsLevelAbove(5) and c:IsAbleToDeck()
end
function c101102018.spfilter2(c,e,tp,tc)
	return c:IsSetCard(0xb2) and not c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101102018.matchfilter(c,e,tp)
    return Duel.IsExistingMatchingCard(c101102018.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c101102018.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
        and Duel.GetMatchingGroup(c101102018.spfilter1,tp,LOCATION_HAND,0,nil):FilterCount(c101102018.matchfilter,nil,e,tp)>0
    end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101102018.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.GetMatchingGroup(c101102018.spfilter1,tp,LOCATION_HAND,0,nil):Filter(c101102018.matchfilter,nil,e,tp)
    if g1:GetCount()<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local tg1=g1:Select(tp,1,1,nil)
    Duel.ConfirmCards(1-tp,tg1)
    if Duel.SendtoDeck(tg1,nil,2,REASON_EFFECT) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g2=Duel.SelectMatchingCard(tp,c101102018.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,tg1:GetFirst())
        if Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP) and e:GetHandler():IsRelateToEffect(e) then
            Duel.BreakEffect()
            Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
        end
    end
end

function c101102018.spfilter(c,ft)
	return c:IsFaceup() and c:IsSetCard(0xb2) and not c:IsCode(101102018) and c:IsAbleToHandAsCost()
		and (ft>0 or c:GetSequence()<5)
end
function c101102018.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c101102018.spfilter,tp,LOCATION_MZONE,0,1,nil,ft)
end
function c101102018.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c101102018.spfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.SendtoHand(g,nil,REASON_COST)
end