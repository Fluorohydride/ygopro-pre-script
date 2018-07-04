--おろかな重葬
--Foolish Mass Burial
function c101006102.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,101006102+EFFECT_COUNT_CODE_OATH)
    e1:SetCost(c101006102.cost)
    e1:SetTarget(c101006102.target)
    e1:SetOperation(c101006102.activate)
    c:RegisterEffect(e1)
    if not c101006102.global_check then
        c101006102.global_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_SSET)
        ge1:SetOperation(c101006102.checkop)
        Duel.RegisterEffect(ge1,0)
    end
end
function c101006102.checkop(e,tp,eg,ep,ev,re,r,rp)
    if eg:IsExists(Card.IsControler,1,nil,tp) then Duel.RegisterFlagEffect(rp,101006102,RESET_PHASE+PHASE_END,0,1) end
end
function c101006102.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,101006102)==0 end
    Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_SSET)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    Duel.RegisterEffect(e1,tp)
end
function c101006102.tgfilter(c)
    return c:IsAbleToGrave()
end
function c101006102.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c101006102.tgfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c101006102.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c101006102.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end
