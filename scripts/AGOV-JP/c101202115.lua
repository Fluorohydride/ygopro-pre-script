--厄灾之星提丰 by 暗之侯爵贝利亚
function c101202115.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,12,2,c101202115.ovfilter,aux.Stringid(101202115,0),2,c101202115.xyzop)
    c:EnableReviveLimit()
    --activate limit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c101202115.actcon)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetValue(c101202115.actlimit)
    c:RegisterEffect(e1)
    --to hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(101202115,0))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCost(c101202115.thcost)
    e2:SetTarget(c101202115.thtg)
    e2:SetOperation(c101202115.thop)
    c:RegisterEffect(e2)
    --SUMMON limit
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e3:SetCondition(c101202115.lmcon)
    e3:SetOperation(c101202115.lmop)
    c:RegisterEffect(e3)
    if not c101202115.global_check then
        c101202115.global_check=true
        local ge1=Effect.CreateEffect(c)
        ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
        ge1:SetCondition(c101202115.xyzcon)
        ge1:SetOperation(c101202115.checkop)
        Duel.RegisterEffect(ge1,0)
    end
end
function c101202115.ovfilter(c)
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    local tg,val=g:GetMaxGroup(Card.GetAttack)
    return c:IsFaceup() and c:IsAttack(val)
end
function c101202115.xyzop(e,tp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,101212115)>0 and Duel.GetFlagEffect(tp,101222115)==0 end
    Duel.RegisterFlagEffect(tp,101222115,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c101202115.xyzcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    return eg:GetCount()==1 and tc:IsSummonLocation(LOCATION_EXTRA) 
end
function c101202115.checkop(e,tp,eg,ep,ev,re,r,rp)
   local tp=e:GetHandler():GetControler()
    local tc=eg:GetFirst()
    while tc do
        Duel.RegisterFlagEffect(tc:GetSummonPlayer(),101202115,RESET_PHASE+PHASE_END,0,1)
        tc=eg:GetNext()
    end
    if Duel.GetFlagEffect(1-tp,101202115)>=2 then
       Duel.RegisterFlagEffect(tp,101212115,RESET_PHASE+PHASE_END,0,2)
    end
end
function c101202115.actcon(e)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c101202115.actlimit(e,re,tp)
    return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsAttackAbove(3000)
end
function c101202115.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c101202115.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101202115.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    if g:GetCount()>0 then
       Duel.SendtoHand(g,nil,REASON_EFFECT)
    end
end
function c101202115.lmcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFlagEffect(tp,101222115)==1
end
function c101202115.lmop(e,tp,eg,ep,ev,re,r,rp)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetCode(EFFECT_CANNOT_SUMMON)
        e1:SetTargetRange(1,0)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        Duel.RegisterEffect(e2,tp)
end