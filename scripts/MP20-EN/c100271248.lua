--Destined Rivals
--Scripted by TOP
function c100271248.initial_effect(c)
    aux.AddCodeList(c,89631139,46986414)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DISABLE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,100271248+EFFECT_COUNT_CODE_OATH)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
    e1:SetCondition(c100271248.condition)
    e1:SetTarget(c100271248.target)
    e1:SetOperation(c100271248.activate)
    c:RegisterEffect(e1)
end
function c100271248.counterfilter(c)
    return not c:IsCode(89631139)
end
function c100271248.cfilter(c)
    return c:IsFaceup() and (c:IsCode(89631139) or c:IsCode(46986414))
end
function c100271248.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c100271248.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end

function c100271248.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.disfilter1,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
    local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_MZONE,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c100271248.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
        tc=g:GetNext()
    end
end

