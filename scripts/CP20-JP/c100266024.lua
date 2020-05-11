--No.3 ゲート・オブ・ヌメロン－トゥリーニ
--Number 3: Numeron Gate Trini
--Scripted by TOP
function c100266024.initial_effect(c)
    --xyz summon
    aux.AddXyzProcedure(c,nil,1,3)
    c:EnableReviveLimit()
    --battle indestructable
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    --atkup
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(100266024,0))
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_DAMAGE_STEP_END)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(c100266024.atkcost)
    e2:SetCondition(c100266024.atkcon)
    e2:SetOperation(c100266024.atkop)
    c:RegisterEffect(e2)
end
c100266024.xyz_number=3
function c100266024.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c100266024.atkcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return bc and bc:IsControler(1-tp)
end
function c100266024.atkfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x24a)
end
function c100266024.atkop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetMatchingGroup(c100266024.atkfilter,tp,LOCATION_MZONE,0,nil)
            local tc=tg:GetFirst()
            while tc do
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_SET_ATTACK_FINAL)
                e1:SetValue(tc:GetAttack()*2)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                tc:RegisterEffect(e1)
                tc=tg:GetNext()
            end
end
