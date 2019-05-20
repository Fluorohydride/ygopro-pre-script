--邪心英雄 恶刃死魔
function c100422012.initial_effect(c)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcFun2(c,c100422012.matfilter,aux.FilterBoolFunction(Card.IsFusionSetCard,0x6008),true)    
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(c100422012.splimit)
    c:RegisterEffect(e1)
    --destroy
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,100422012)
    e2:SetTarget(c100422012.destg)
    e2:SetOperation(c100422012.desop)
    c:RegisterEffect(e2)
    --indes
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e4)
end
c100422012.material_setcode=0x8
c100422012.dark_calling=true
function c100422012.splimit(e,se,sp,st)
    return st==SUMMON_TYPE_FUSION+0x10
end
function c100422012.matfilter(c)
    return c:IsLevelAbove(5) and c:IsType(TYPE_MONSTER)
end
function c100422012.filter(c,atk)
    return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c100422012.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(c100422012.filter,tp,0,LOCATION_MZONE,1,c,c:GetAttack()) end
    local g=Duel.GetMatchingGroup(c100422012.filter,tp,0,LOCATION_MZONE,c,c:GetAttack())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*500)
end
function c100422012.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    local g=Duel.GetMatchingGroup(c100422012.filter,tp,0,LOCATION_MZONE,nil,c:GetAttack())
    local ct=Duel.Destroy(g,REASON_EFFECT)
    if ct>0 then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
        e1:SetValue(ct*200)
        c:RegisterEffect(e1)
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
    e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OATH)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(c100422012.atktg)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c100422012.atktg(e,c)
    return not c:IsSetCard(0x8)
end