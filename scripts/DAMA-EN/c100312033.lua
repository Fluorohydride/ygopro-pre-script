--Lost Sanctuary
function c100312033.initial_effect(c)
    --When this card is activated: Set 1 "The Sanctuary in the Sky", or 1 Spell/Trap that specifically lists that card in its text, directly from your Deck. You can only activate 1 "Lost Sanctuary" per turn.
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,100312033+EFFECT_COUNT_CODE_OATH)
    e2:SetTarget(c100312033.target)
    e2:SetOperation(c100312033.activate)
    c:RegisterEffect(e1)
    --This card's name becomes "The Sanctuary in the Sky" while on the field or in the GY.
    aux.EnableChangeCode(c,56433456,LOCATION_SZONE+LOCATION_GRAVE)
    --You can banish 1 Fairy monster from your GY, then target 1 Effect Monster your opponent controls; negate its effects until the end of this turn (even if this card leaves the field). You can only use this effect of "Lost Sanctuary" once per turn.
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_SZONE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCategory(CATEGORY_DISABLE)
    e2:SetCountLimit(1,100312133)
    e2:SetCost(c100312033.cost)
    e2:SetTarget(c100312033.distg)
    e2:SetOperation(c100312033.disop)
    c:RegisterEffect(e2)
end
function c100312033.filter(c)
    return (c:IsCode(56433456) or aux.IsCodeListed(c,56433456)) and c:IsSSetable()
end
function c100312033.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingMatchingCard(c100312033.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c100312033.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local tc=Duel.SelectMatchingCard(tp,c100312033.filter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
    if tc then
        Duel.SSet(tp,tc)
    end
end
function c100312033.cfilter(c)
    return c:IsRace(RACE_FAIRY) and c:IsAbleToRemoveAsCost()
end
function c100312033.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c100312033.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c100312033.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c100312033.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and aux.NegateEffectMonsterFilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
    local g=Duel.SelectTarget(tp,aux.NegateEffectMonsterFilter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c100312033.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsDisabled() then
        Duel.NegateRelatedChain(tc,RESET_TURN_SET)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetValue(RESET_TURN_SET)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
    end
end
