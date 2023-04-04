-- DUNE-JP023 邪炎帝王テスタロス Jaenteiou Thestalos (Thestalos the Shadow Firestorm Monarch)
-- Level 10 FIRE Pyro Effect Monster
-- ATK 3000
-- DEF 1000
-- Scripted by Catto (=｀ω´=) and Ralph
local s, id, o = GetID()

function s.initial_effect(c)
    -- You can Tribute Summon this card by Tributing 1 monster your opponent controls 
    -- and 1 Tribute Summoned monster you control.
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCode(EFFECT_SUMMON_PROC)
    e1:SetCondition(s.otcon)
    e1:SetOperation(s.otop)
    e1:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e1)

    -- Tribute Set
    local e2 = e1:Clone()
    e2:SetCode(EFFECT_SET_PROC)
    c:RegisterEffect(e2)

    -- If this card is Tribute Summoned: You can banish 1 random card from your opponent’s hand, and if you do, inflict 1000 damage to them
    -- then, if this card was Tribute Summoned by Tributing a Level 8 or higher monster, you can banish 1 card on the field, 
    -- and if it is a FIRE or DARK Monster Card, inflict damage to your opponent equal to its original Level x 200.
end

function s.otfilter(c)
    return c:IsSummonType(SUMMON_TYPE_ADVANCE)
end

-- Check if opponent has at least one tributable monster on their field
function s.oppfilter(c, tp)
    local tp = c:GetControler()
    return c:IsReleasable() and Duel.GetMZoneCount(1 - tp, c, tp) > 0
end

function s.otcon(e, c, minc)
    if c == nil then
        return true
    end

    -- Get turn player
    local tp = c:GetControler()
    return minc <= 2 and Duel.IsExistingMatchingCard(s.otfilter, tp, LOCATION_MZONE, 0, 1, nil, e, tp) and
               Duel.IsExistingMatchingCard(s.oppfilter, tp, 0, LOCATION_MZONE, 1, nil, e)
end

function s.otop(e, tp, eg, ep, ev, re, r, rp, c)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TRIBUTE)
    local g1 = Duel.SelectMatchingCard(tp, s.otfilter, tp, LOCATION_MZONE, 0, 1, 1, nil, e, tp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TRIBUTE)
    local g2 = Duel.SelectMatchingCard(tp, s.oppfilter, tp, 0, LOCATION_MZONE, 1, 1, nil, e)
    g1:Merge(g2)

    -- Mark cards in group as used for a material
    c:SetMaterial(g1)

    -- Actually tributes the cards
    Duel.Release(g1, REASON_MATERIAL + REASON_SUMMON)
end
