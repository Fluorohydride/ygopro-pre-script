--クロノダイバー・レトログラード

--Scripted by mallu11
function c101011075.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_NEGATE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCountLimit(1,101011075+EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(c101011075.condition)
    e1:SetTarget(c101011075.target)
    e1:SetOperation(c101011075.activate)
    c:RegisterEffect(e1)
end
function c101011075.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x126) and c:IsType(TYPE_XYZ)
end
function c101011075.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c101011075.cfilter,tp,LOCATION_MZONE,0,1,nil)
        and re:IsHasType(EFFECT_TYPE_ACTIVATE) 
        and Duel.IsChainNegatable(ev)
end
function c101011075.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c101011075.activate(e,tp,eg,ep,ev,re,r,rp)
    local ec=re:GetHandler()
    if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) 
        and Duel.IsExistingMatchingCard(c101011075.cfilter,tp,LOCATION_MZONE,0,1,nil) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
        local tc=Duel.SelectMatchingCard(tp,c101011075.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
        if not tc:GetFirst():IsImmuneToEffect(e) then
            ec:CancelToGrave()
            Duel.Overlay(tc:GetFirst(),Group.FromCards(ec))
        end
    end
end
