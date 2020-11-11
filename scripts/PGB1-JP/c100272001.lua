--Thunderforce Attack
--scripted by TOP
function c100272001.initial_effect(c)
    aux.AddCodeList(c,10000020)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(100272001,0))
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
    e1:SetCountLimit(1,100272001+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(c100272001.descon)
    e1:SetTarget(c100272001.destg)
    e1:SetOperation(c100272001.desop)
    c:RegisterEffect(e1)
    if not c69145169.global_check then
        c69145169.global_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
        ge1:SetOperation(c100272001.checkop)
        Duel.RegisterEffect(ge1,0)
    end
end
function c100272001.checkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    local p=tc:GetControler()
    if tc:GetFlagEffect(69145169)==0 then
        tc:RegisterFlagEffect(69145169,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
        if Duel.GetFlagEffect(p,69145169)==0 then
            Duel.RegisterFlagEffect(p,69145169,RESET_PHASE+PHASE_END,0,1)
        else
            Duel.RegisterFlagEffect(p,69145170,RESET_PHASE+PHASE_END,0,1)
        end
    end
end
function c100272001.actfilter(c)
    return c:IsFaceup() and c:IsOriginalCodeRule(10000020)
end
function c100272001.descon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c100272001.actfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c100272001.desfilter(c)
    return c:IsFaceup()
end
function c100272001.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetMatchingGroup(c100272001.desfilter,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
    if g:GetCount()~=0 then
        Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,g:GetCount())
    end
end
function c100272001.sgfilter(c,p)
    return c:IsLocation(LOCATION_GRAVE) and c:IsControler(p)
end
function c100272001.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c100272001.desfilter,tp,0,LOCATION_MZONE,nil)
    if Duel.Destroy(g,REASON_EFFECT)~=0 then
    local dc=Duel.GetOperatedGroup():FilterCount(c100272001.sgfilter,nil,1-tp)
    if dc~=0 and Duel.GetFlagEffect(tp,69145170)==0 and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.SelectYesNo(tp,aux.Stringid(100272001,0)) then
    Duel.BreakEffect()
    Duel.Draw(tp,dc,REASON_EFFECT)
    --cannot attack
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetCondition(c100272001.atkcon)
    e1:SetTarget(c100272001.atktg)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
    end
end

function c100272001.atkcon(e)
    return Duel.GetFlagEffect(e:GetHandlerPlayer(),69145169)~=0
end
function c100272001.atktg(e,c)
    return c:GetFlagEffect(69145169)==0
end
