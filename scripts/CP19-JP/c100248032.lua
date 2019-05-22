--No.76 諧調光師グラディエール
--
--Scripted by 龙骑
function c100248032.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,7,2)
    c:EnableReviveLimit() 
    --Attribute
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_ADJUST)
    e1:SetRange(LOCATION_MZONE)
    e1:SetOperation(c100248032.efop)
    c:RegisterEffect(e1)
    --indes battle
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)  
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetValue(c100248032.indval)
    c:RegisterEffect(e2)  
    --indes effect
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e3:SetValue(c100248032.indcon)
    e3:SetValue(aux.tgoval)
    c:RegisterEffect(e3)
    --
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_MZONE)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetCountLimit(1,100248032)
    e4:SetTarget(c100248032.xyztg)
    e4:SetOperation(c100248032.xyzop)
    c:RegisterEffect(e4)
end
function c100248032.effilter(c)
    return c:IsType(TYPE_MONSTER)
end
function c100248032.efop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()  
    local ct=c:GetOverlayGroup(tp,1,0)
    local wg=ct:Filter(c100248032.effilter,nil,tp)
    local wbc=wg:GetFirst()
    while wbc do
        local code=wbc:GetOriginalCode()
        local att=wbc:GetOriginalAttribute()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_ADD_ATTRIBUTE)
        e1:SetValue(att)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        c:RegisterEffect(e1) 
        wbc=wg:GetNext()
    end
end
function c100248032.indval(e,c)
    return not c:GetBattleTarget():GetAttribute()~=c:GetAttribute()
end
function c100248032.indcon(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActivated() and not te:GetHandler():GetAttribute()~=e:GetHandler():GetAttribute()
end
function c100248032.xyzfilter(c)
    return c:IsType(TYPE_MONSTER)
end
function c100248032.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(c100248032.xyzfilter,tp,0,LOCATION_GRAVE,1,nil) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,c100248032.xyzfilter,tp,0,LOCATION_GRAVE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c100248032.rmop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) then
        c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
        Duel.Overlay(c,Group.FromCards(tc))
    end
end
