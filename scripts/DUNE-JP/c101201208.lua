-- DUNE-JP077 断絶の落とし穴 Danzetsu no Otoshiana (Wipeout Trap Hole/Erasure Trap Hole)
-- Normal Trap Card 
-- When your opponent Summons a monster(s) with 1500 or less ATK: Banish that monster(s) with 1500 or less ATK, face-down.
-- Scripted by Catto (=｀ω´=)
local s, id, o = GetID()

function s.initial_effect(c)
    -- Activate(summon)
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)

    local e2 = Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_ACTIVATE)
    e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    e2:SetTarget(s.target)
    e2:SetOperation(s.activate)
    c:RegisterEffect(e2)

    local e3 = Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_REMOVE)
    e3:SetType(EFFECT_TYPE_ACTIVATE)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetTarget(s.target2)
    e3:SetOperation(s.activate2)
    c:RegisterEffect(e3)
end

function s.filter(c, tp, ep)
    return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetAttack() <= 1500 and ep ~= tp and
               c:IsAbleToRemove(tp, POS_FACEDOWN)
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    local tc = eg:GetFirst()
    if chk == 0 then
        return s.filter(tc, tp, ep)
    end
    Duel.SetTargetCard(eg)
    Duel.SetOperationInfo(0, CATEGORY_REMOVE, tc, 1, 0, 0)
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
    local tc = eg:GetFirst()
    if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetAttack() <= 1500 then
        Duel.Remove(tc, POS_FACEDOWN, REASON_EFFECT)
    end
end

function s.filter2(c, tp)
    return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetAttack() <= 1500 and c:IsSummonPlayer(1 - tp) and
               c:IsAbleToRemove(tp, POS_FACEDOWN)
end

function s.target2(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return eg:IsExists(s.filter2, 1, nil, tp)
    end
    local g = eg:Filter(s.filter2, nil, tp)
    Duel.SetTargetCard(eg)
    Duel.SetOperationInfo(0, CATEGORY_REMOVE, g, g:GetCount(), 0, 0)
end

function s.filter3(c, e, tp)
    return c:IsFaceup() and c:GetAttack() <= 1500 and c:IsSummonPlayer(1 - tp) and c:IsRelateToEffect(e) and
               c:IsLocation(LOCATION_MZONE)
end

function s.activate2(e, tp, eg, ep, ev, re, r, rp)
    local g = eg:Filter(s.filter3, nil, e, tp)
    if g:GetCount() > 0 then
        Duel.Remove(tc, POS_FACEDOWN, REASON_EFFECT)
    end
end
