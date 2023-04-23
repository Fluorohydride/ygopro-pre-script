--百戦王ウォー・キング ベヒーモス
--Behemoth the King of All Wars
--Script by VoidBehemoth
local s, id = GetID()

function s.initial_effect(c)
    -- Summon with 1 tribute
    local one_tribute = Effect.CreateEffect(c)
    one_tribute:SetDescription(aux.Stringid(id, 0))
    one_tribute:SetProperty(EFFECT_FLAG_CANNOT_DISABLE | EFFECT_FLAG_UNCOPYABLE)
    one_tribute:SetCategory(CATEGORY_SUMMON)
    one_tribute:SetType(EFFECT_TYPE_SINGLE)
    one_tribute:SetCode(EFFECT_SUMMON_PROC)
    one_tribute:SetCondition(s.one_tribute_condition)
    one_tribute:SetOperation(s.one_tribute_operation)
    one_tribute:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(one_tribute)

    -- Add beast from GY on summon
    local add_beast = Effect.CreateEffect(c)
    add_beast:SetDescription(aux.Stringid(id, 1))
    add_beast:SetProperty(EFFECT_FLAG_CARD_TARGET | EFFECT_FLAG_DELAY)
    add_beast:SetCategory(CATEGORY_TOHAND | CATEGORY_LEAVE_GRAVE)
    add_beast:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    add_beast:SetCode(EVENT_SUMMON_SUCCESS + EVENT_SPSUMMON_SUCCESS)
    add_beast:SetTarget(s.add_beast_target)
    add_beast:SetOperation(s.add_beast_target)
    c:RegisterEffect(add_beast)

    -- Unaffected if normal summoned / set
    local unaffected = Effect.CreateEffect(c)
    unaffected:SetDescription(aux.Stringid(id, 2))
    unaffected:SetType(EFFECT_TYPE_SINGLE)
    unaffected:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    unaffected:SetRange(LOCATION_MZONE)
    unaffected:SetCode(EFFECT_IMMUNE_EFFECT)
    unaffected:SetValue(s.immune_filter)
    c:RegisterEffect(unaffected)

    -- Gain 700 ATK
    local increase_atk = Effect.CreateEffect(c)
    increase_atk:SetDescription(aux.Stringid(id, 3))
    increase_atk:SetCategory(CATEGORY_ATKCHANGE)
    increase_atk:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    increase_atk:SetRange(LOCATION_MZONE)
    increase_atk:SetCode(EVENT_PHASE + PHASE_END + EFFECT_UPDATE_ATTACK)
    increase_atk:SetValue(700)
    increase_atk:SetCountLimit(1)
    c:RegisterEffect(increase_atk)
end

function s.one_tribute_condition(e, c, minc)
    if c == nil then return true end
    return c:IsLevelAbove(9) and minc <= 1 and Duel.CheckTribute(c, 1)
end

function s.one_tribute_operation(e, tp, eg, ep, ev, re, r, rp, c)
    local g = Duel.SelectTribute(tp, c, 1, 1)
    c:SetMaterial(g)
    Duel.Release(g, REASON_SUMMON + REASON_MATERIAL)
end

function s.add_beast_target(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then
        return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.add_filter(chkc)
    end
    if chk == 0 then
        return Duel.IsExistingTarget(s.add_filter, tp, LOCATION_GRAVE, 0, 1, nil)
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
    local g = Duel.SelectTarget(tp, s.add_filter, tp, LOCATION_GRAVE, 0, 1, 1, nil)
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, g, #g, 0, 0)
end

function s.add_beast_operation(e, tp, eg, ep, ev, re, r, rp)
    local tc = Duel.GetFirstTarget()
    local c = e:GetHandler()
    if tc and tc:IsRelateToChain(0) then
        Duel.SendtoHand(tc, tp, REASON_EFFECT)

        -- decrease ATK by 700
        local decrease_atk = Effect.CreateEffect(c)
        decrease_atk:SetType(EFFECT_TYPE_SINGLE)
        decrease_atk:SetCode(EFFECT_UPDATE_ATTACK)
        decrease_atk:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_DISABLE)
        decrease_atk:SetValue(-700)
        c:RegisterEffect(decrease_atk)
    end
end

function s.add_filter(c)
    return c:Race(RACE_BEAST | RACE_BEASTWARRIOR | RACE_WINGEDBEAST) and c:IsAbleToHand()
end

function s.immune_filter(e, te)
    local tc = te:GetOwner()
    local c = e:GetHandler()
    return tc:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsSummonType(SUMMON_TYPE_NORMAL) and te:IsActiveType(TYPE_MONSTER) and te:IsActivated() and te:GetActivateLocation() == LOCATION_MZONE
end