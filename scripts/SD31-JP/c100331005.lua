--白翼の魔術師
--White Wing Magician
--Scripted by Eerie Code
function c100331005.initial_effect(c)
    aux.EnablePendulumAttribute(c)
    --Negate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(c100331005.condition)
    e1:SetTarget(c100331005.target)
    e1:SetOperation(c100331005.operation)
    c:RegisterEffect(e1)
    --Banish
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetValue(LOCATION_REMOVED)
    e2:SetCondition(c100331005.rmcon)
    c:RegisterEffect(e2)
end
function c100331005.cfilter(c,tp)
    return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsControler(tp)
end
function c100331005.condition(e,tp,eg,ep,ev,re,r,rp)
    if not (re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
        and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))) then return false end
    local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return tg and tg:GetCount()>0 and tg:IsExists(c100331005.cfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c100331005.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsDestructable() end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c100331005.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.NegateActivation(ev)
        Duel.BreakEffect()
        Duel.Destroy(c,REASON_EFFECT)
    end
end
function c100331005.rmcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return bit.band(c:GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM and c:IsReason(REASON_MATERIAL) and c:IsReason(REASON_SYNCHRO)
end
