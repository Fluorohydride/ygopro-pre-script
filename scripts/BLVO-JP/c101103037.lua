--鎧竜の聖騎士
--Paladin of Armored Dragon
--Script by TheOnePharaoh
function c101103037.initial_effect(c)
    c:EnableReviveLimit()
    --to deck
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(101103037,0))
    e1:SetCategory(CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_BATTLE_START)
    e1:SetCountLimit(1,101103037)
    e1:SetCondition(c101103037.dcon)
    e1:SetTarget(c101103037.dtg)
    e1:SetOperation(c101103037.dop)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,75901114)
    e2:SetCost(c101103037.spcost)
    e2:SetTarget(c101103037.sptg)
    e2:SetOperation(c101103037.spop)
    c:RegisterEffect(e2)
end
function c101103037.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function c101103037.spfilter(c,e,tp)
    return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsLevelAbove(5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101103037.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
        and Duel.IsExistingMatchingCard(c101103037.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c101103037.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c101103037.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
