--百戦王ウォー・キング ベヒーモス
--Behemoth the King of All Wars
--Script by VoidBehemoth
local s, id = GetID()

function s.initial_effect(c)
    -- Summon with 1 tribute
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE | EFFECT_FLAG_UNCOPYABLE)
    e1:SetCategory(CATEGORY_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SUMMON_PROC)
    e1:SetCondition(s.otcon)
    e1:SetOperation(s.otop)
    e1:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e1)

    -- Add beast from GY on summon
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 1))
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET | EFFECT_FLAG_DELAY)
    e2:SetCategory(CATEGORY_TOHAND | CATEGORY_LEAVE_GRAVE)
    e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SUMMON_SUCCESS + EVENT_SPSUMMON_SUCCESS)
    e2:SetTarget(s.abtar)
    e2:SetOperation(s.abop)
    c:RegisterEffect(e2)

    -- Unaffected if normal summoned / set
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 2))
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetValue(s.immune_filter)
    c:RegisterEffect(e3)

    -- Gain 700 ATK
    local e4 = Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id, 3))
    e4:SetCategory(CATEGORY_ATKCHANGE)
    e4:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EVENT_PHASE + PHASE_END + EFFECT_UPDATE_ATTACK)
    e4:SetValue(700)
    e4:SetCountLimit(1)
    e4:SetCondition(s.atkcon)
    e4:SetOperation(s.atkop)
    c:RegisterEffect(e4)
end

function s.otcon(e, c, minc)
    if c == nil then return true end
    return c:IsLevelAbove(9) and minc <= 1 and Duel.CheckTribute(c, 1)
end



function s.otop(e, tp, eg, ep, ev, re, r, rp, c)
    local g = Duel.SelectTribute(tp, c, 1, 1)
    c:SetMaterial(g)
    Duel.Release(g, REASON_SUMMON + REASON_MATERIAL)
end

function s.atkcon(e, tp, eg, ep, ev, re, r, rp)
    return tp == Duel.GetTurnPlayer()
end

function s.atkop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local e1 = Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(700)
        e1:SetReset(RESET_EVENT + RESETS_STANDARD+RESET_DISABLE)
        c:RegisterEffect(e1)
    end
end

function s.abtar(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
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

function s.abop(e, tp, eg, ep, ev, re, r, rp)
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