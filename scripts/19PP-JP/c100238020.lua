--倍倍伤害]
--Script by Djeeta
function c100238020.initial_effect(c)
    --Baibai Damage
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e1:SetCountLimit(1,100238020)
    e1:SetCondition(c100238020.condition)
    e1:SetOperation(c100238020.activate)
    c:RegisterEffect(e1)    
end
function c100238020.condition(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
    local d=a:GetBattleTarget()
    e:SetLabelObject(d)
    return a:IsControler(1-tp) and d and d:IsControler(tp)
end
function c100238020.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        local tc=e:GetLabelObject()
        if not tc:IsRelateToBattle() then return end
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
        e1:SetValue(1)
        e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetCategory(CATEGORY_DAMAGE)
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_BATTLE_DAMAGE)
        e2:SetOperation(c100238020.damop)
        e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
        Duel.RegisterEffect(e2,tp)        
    end
end
function c100238020.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Damage(1-tp,ev*2,REASON_EFFECT)
end
