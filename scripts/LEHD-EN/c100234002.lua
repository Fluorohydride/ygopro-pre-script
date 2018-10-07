--Gullveig of the Nordic Ascendant
--Scripted by Eerie Code
function c100234002.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,c100234002.matfilter,1,1)
    --banish and summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(100234002,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,100234002)
    e1:SetCondition(c100234002.spcon)
    e1:SetTarget(c100234002.sptg)
    e1:SetOperation(c100234002.spop)
    c:RegisterEffect(e1)
    --cannot be target
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e2:SetCondition(c100234002.tgcon)
    e2:SetTarget(c100234002.tgtg)
    e2:SetValue(aux.tgoval)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c100234002.tgcon)
    e3:SetValue(aux.imval1)
    c:RegisterEffect(e3)
end
function c100234002.matfilter(c)
    return c:IsLinkSetCard(0x42) and c:IsLevelBelow(5)
end
function c100234002.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c100234002.spfilter(c,e,tp)
    return c:IsSetCard(0x42) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c100234002.spcheck(sg,e,tp,mg)
    return Duel.GetMZoneCount(tp,sg,tp,LOCATION_REASON_TOFIELD)>=#sg and Duel.IsExistingMatchingCard(c100234002.spfilter,tp,LOCATION_DECK,0,#sg,nil,e,tp)
end
function c100234002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
    if chk==0 then return aux.SelectUnselectGroup(g,e,tp,1,3,c100234002.spcheck,0) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c100234002.spop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
    local ct=3
    if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ct=1 end
    local rg=aux.SelectUnselectGroup(g,e,tp,1,ct,c100234002.spcheck,1,tp,HINTMSG_REMOVE)
    if #rg>0 and Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)~=0 then
        ct=math.min(#(Duel.GetOperatedGroup()),Duel.GetLocationCount(tp,LOCATION_MZONE))
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=Duel.SelectMatchingCard(tp,c100234002.spfilter,tp,LOCATION_DECK,0,ct,ct,nil,e,tp)
        Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c100234002.splimit)
    Duel.RegisterEffect(e1,tp)
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e2:SetCode(EFFECT_CANNOT_SUMMON)
    e2:SetReset(RESET_PHASE+PHASE_END)
    e2:SetTargetRange(1,0)
    Duel.RegisterEffect(e2,tp)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_CANNOT_SET)
    Duel.RegisterEffect(e3,tp)
end
function c100234002.splimit(e,c)
    return not c:IsSetCard(0x4b)
end
function c100234002.tgfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x4b)
end
function c100234002.tgcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetLinkedGroup():IsExists(c100234002.tgfilter,1,nil)
end
function c100234002.tgtg(e,c)
    return c100234002.tgfilter(c) and e:GetHandler():GetLinkedGroup():IsContains(c)
end
