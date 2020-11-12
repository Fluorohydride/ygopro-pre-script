--フェアリーテールロチカ
--Fairy Tail Rohka
--LUA by Kohana Sonogami
--
function c100270222.initial_effect(c)
    --confirm
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(100270222, 0))
    e1:SetCategory(CATEGORY_RECOVER + CATEGORY_SEARCH + CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1,100270222)
    e1:SetTarget(c100270222.thtg)
    e1:SetOperation(c100270222.thop)
    c:RegisterEffect(e1)
    --send to gy
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(100270222, 1))
    e2:SetCategory(CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_BATTLE_CONFIRM)
    e2:SetCountLimit(1,100270222 + 100)
    e2:SetCondition(c100270222.batlcon)
    e2:SetTarget(c100270222.batltg)
    e2:SetOperation(c100270222.batlop)
    c:RegisterEffect(e2)
end
function c100270222.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk == 0 then
        return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)> 2
    end
    Duel.SetTargetPlayer(1 - tp)
    Duel.SetTargetParam(500)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,500)
end
function c100270222.thop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then
        return
    end
    local p,d=Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
    if Duel.Recover(p, d, REASON_EFFECT)~=0 then
        if not e:GetHandler():IsRelateToEffect(e) then
            return
        end
        if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then
            return
        end
        local g=Duel.GetDecktopGroup(tp,3)
        if #g>0 then
            Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
            local sc=g:Select(1 - tp,1,1,nil):GetFirst()
            if sc:IsAbleToHand() then
                Duel.SendtoHand(sc,nil,REASON_EFFECT)
                Duel.ConfirmCards(1-tp,sc)
                Duel.ShuffleHand(tp)
            else
                Duel.SendtoGrave(sc, REASON_RULE)
            end
            Duel.ShuffleDeck(tp)
        end
    end
end
function c100270222.batlcon(e, tp, eg, ep, ev, re, r, rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    return c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsRelateToBattle()
end
function c100270222.batltg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then
        return c:IsAbleToGrave()
    end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,c,1,tp,0)
end
function c100270222.batlop(e,tp,eg,ep,ev,re,r,rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoGrave(c, REASON_EFFECT)
    end
end