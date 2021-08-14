--Beetrooper Fly & Sting
function c101105091.initial_effect(c)
    --You can only use 1 "Beetrooper Fly & Sting" effect per turn, and only once that turn.
    --When your opponent activates a monster effect, while you control a "Beetrooper" monster: Negate the activation, and if you do, destroy it.
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCountLimit(1,101105091)
    e1:SetCondition(c101105091.condition)
    e1:SetTarget(c101105091.target)
    e1:SetOperation(c101105091.activate)
    c:RegisterEffect(e1)
    --During your End Phase, if this card is in your GY and you control an Insect monster with 3000 or more ATK: You can banish 1 Insect monster from your GY; Set this card.
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_PHASE+PHASE_END)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,101105091)
    e2:SetCondition(c101105091.setcon)
    e2:SetCost(c101105091.cost)
    e2:SetTarget(c101105091.settg)
    e2:SetOperation(c101105091.setop)
    c:RegisterEffect(e2)
end
function c101105091.condition(e,tp,eg,ep,ev,re,r,rp)
    return rp~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
        and Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsSetCard),tp,LOCATION_MZONE,0,1,nil,0x270)
end
function c101105091.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c101105091.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end
function c101105091.filter(c)
    return c:IsFaceup() and c:IsRace(RACE_INSECT) and c:IsAttackAbove(3000)
end
function c101105091.setcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c101105091.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c101105091.cfilter(c)
    return c:IsRace(RACE_INSECT) and c:IsAbleToRemoveAsCost()
end
function c101105091.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c101105091.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c101105091.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101105091.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsSSetable() end
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function c101105091.setop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then Duel.SSet(tp,c) end
end
