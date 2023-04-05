-- DUNE-JP012 Veda Karantha
-- Scripted by Catto (=｀ω´=) and Ralph
local s, id, o = GetID()

function s.initial_effect(c)
    -- special summon
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e1:SetRange(LOCATION_HAND)
    e1:SetCode(EVENT_DESTROYED)
    e1:SetCountLimit(1, id)
    e1:SetCondition(s.spcon)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    -- increase atk
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 1))
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1, id)
    e2:SetCondition(s.atkcon)
    e2:SetTarget(s.atktg)
    e2:SetOperation(s.atkop)
    c:RegisterEffect(e2)
end
function s.spfilter(c, tp)
    return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler() == tp
end
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
    return eg:IsExists(s.spfilter, 1, nil, tp) and
               Duel.IsExistingMatchingCard(Card.IsFaceup, tp, LOCATION_ONFIELD, 0, 1, nil) and
               Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_DECK + LOCATION_GRAVE, 0, 1, nil, 21570001)
end
function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
    end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_SEARCH, nil, 1, tp, LOCATION_DECK + LOCATION_GRAVE)
end
function s.spop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP) > 0 then
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
        local g = Duel.SelectMatchingCard(tp, Card.IsCode, tp, LOCATION_DECK + LOCATION_GRAVE, 0, 1, 1, nil, 21570001)
        if g:GetCount() > 0 then
            Duel.SendtoHand(g, nil, REASON_EFFECT)
            Duel.ConfirmCards(1 - tp, g)
        end
    end
end
function s.atkconfilter(c, tp)
    return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp) and c:IsReason(REASON_EFFECT)
end
function s.atkcon(e, tp, eg, ep, ev, re, r, rp)
    return eg:IsExists(s.atkconfilter, 1, nil, tp) and not eg:IsContains(e:GetHandler())
end
function s.atktgfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function s.atktg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.atktgfilter, tp, 0, LOCATION_MZONE, 1, nil, e)
    end
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, nil, 1, tp, LOCATION_MZONE)
end
function s.atkop(e, tp, eg, ep, ev, re, r, rp)
    -- Choose a monster on the opponent's field and destroy it
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
    local g = Duel.SelectMatchingCard(tp, s.atktgfilter, tp, 0, LOCATION_MZONE, 1, 1, nil, e)
    if g:GetCount() > 0 then
        Duel.Destroy(g, REASON_EFFECT)
        -- If a monster was destroyed by this effect, increase the ATK of this card by the original ATK of the destroyed monster
        local tc = g:GetFirst()
        if tc:IsType(TYPE_MONSTER) then
            local atk = tc:GetBaseAttack()
            if atk > 0 then
                local e1 = Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_ATTACK)
                e1:SetValue(atk)
                e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
                e:GetHandler():RegisterEffect(e1)
            end
        end
    end
end
