--粛声の竜賢聖サウラヴィス
--scripted by REIKAI
local s,id,o=GetID()
function s.initial_effect(c)
    --special summon
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_HAND)
    e0:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
    e0:SetCondition(s.sprcon)
    e0:SetOperation(s.sprop)
    c:RegisterEffect(e0)
    --SpecialSummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,1))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,id+o)
    e1:SetCondition(s.con)
    e1:SetCost(s.cost)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end
function s.sprfilter(c)
    return c:IsType(TYPE_SPELL) and c:IsAbleToDeckAsCost()
end
function s.gfilter(g)
    return g:IsExists(Card.IsType,1,nil,TYPE_RITUAL)
end
function s.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and g:CheckSubGroup(s.gfilter,2,2)
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local sg=g:SelectSubGroup(tp,s.gfilter,false,2,2)
    Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
    return rp==1-tp
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToHandAsCost() end
    Duel.SendtoHand(c,tp,REASON_COST)
end
function s.filter(c,e,tp)
    return  c:IsRace(RACE_DRAGON+RACE_WARRIOR) and c:IsType(TYPE_RITUAL) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
        and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        local sc=g:GetFirst()
        if Duel.SpecialSummonStep(sc,0,tp,tp,false,true,POS_FACEUP) then
            sc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
            e1:SetCode(EVENT_PHASE+PHASE_END)
            e1:SetCountLimit(1)
            e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
            e1:SetLabel(Duel.GetTurnCount())
            e1:SetLabelObject(sc)
            e1:SetCondition(s.tdcon)
            e1:SetOperation(s.tdop)
            e1:SetReset(RESET_PHASE+PHASE_END,2)
            Duel.RegisterEffect(e1,tp)
        end
        Duel.SpecialSummonComplete()
    end
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(id)~=0
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end