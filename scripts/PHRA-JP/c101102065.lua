--New Style Fur Hire
--scripted by TOP
function c101102065.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetLabel(0)
    e1:SetCountLimit(1,101102065+EFFECT_COUNT_CODE_OATH)
    e1:SetCost(c101102065.cost)
    e1:SetTarget(c101102065.target)
    e1:SetOperation(c101102065.activate)
    c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(101102065,ACTIVITY_ATTACK,c101102065.counterfilter)
end
function c101102065.counterfilter(c)
    return c:IsSetCard(0x114)
end
function c101102065.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    e:SetLabel(100)
    if chk==0 then return Duel.GetCustomActivityCount(101102065,tp,ACTIVITY_ATTACK)==0 end
end
function c101102065.cfilter(c,e,tp)
    local lv=c:GetOriginalLevel()
      return bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and lv>0 and c:IsFaceup() and c:IsAbleToGraveAsCost()
        and Duel.IsExistingMatchingCard(c101102065.spfilter,tp,LOCATION_DECK,0,1,nil,lv+1,e,tp)
end
function c101102065.spfilter(c,lv,e,tp)
    return c:IsSetCard(0x114) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101102065.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        if e:GetLabel()~=100 then return false end
        e:SetLabel(0)
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
            and Duel.IsExistingMatchingCard(c101102065.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
    end
    e:SetLabel(0)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c101102065.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    Duel.SendtoGrave(tc,REASON_COST)
    Duel.SetTargetCard(tc)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101102065.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c101102065.spfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetLevel()+1,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
