--骰子迷宫
--id:Ruby QQ:917770701
function c100290005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c100290005.activate)
	c:RegisterEffect(e1)
    --dice roll
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100290005,1))
	e2:SetCategory(CATEGORY_DICE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c100290005.dicetg)
	e2:SetOperation(c100290005.diceop)
	c:RegisterEffect(e2)
end
c100290005.toss_dice=true
function c100290005.thfilter(c)
	return c:IsCode(100290006) and c:IsAbleToHand()
end
function c100290005.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100290005.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(100290005,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c100290005.dicetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,PLAYER_ALL,1)
end
function c100290005.diceop(e,tp,eg,ep,ev,re,r,rp)
	local d1=Duel.TossDice(tp,1)
	local d2=Duel.TossDice(1-tp,1)
--first dice
    if d1  ==  1 then
        local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
        if g:GetCount()>0 then
            local sc=g:GetFirst()
            while sc do
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_ATTACK)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                e1:SetValue(-1000)
                sc:RegisterEffect(e1)
                sc=g:GetNext()
            end
        end
    elseif d1 == 2 then
        local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
        if g:GetCount()>0 then
            local sc=g:GetFirst()
            while sc do
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_ATTACK)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                e1:SetValue(1000)
                sc:RegisterEffect(e1)
                sc=g:GetNext()
            end
        end
    elseif d1 == 3 then
        local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
        if g:GetCount()>0 then
            local sc=g:GetFirst()
            while sc do
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_ATTACK)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                e1:SetValue(-500)
                sc:RegisterEffect(e1)
                sc=g:GetNext()
            end
        end
    elseif d1 == 4 then
        local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
        if g:GetCount()>0 then
            local sc=g:GetFirst()
            while sc do
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_ATTACK)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                e1:SetValue(500)
                sc:RegisterEffect(e1)
                sc=g:GetNext()
            end
        end
    elseif d1 == 5 then
        local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
        if g:GetCount()>0 then
            local sc=g:GetFirst()
            while sc do
                local atk=sc:GetAttack()
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_SET_ATTACK_FINAL)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                e1:SetValue(math.ceil(atk/2))
                sc:RegisterEffect(e1)
                sc=g:GetNext()
            end
        end
    elseif d1 == 6 then
        local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
        if g:GetCount()>0 then
            local sc=g:GetFirst()
            while sc do
                local atk=sc:GetAttack()
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_SET_ATTACK_FINAL)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                e1:SetValue(atk*2)
                sc:RegisterEffect(e1)
                sc=g:GetNext()
            end
        end
    else
        return
    end
--second dice
    if d2  ==  1 then
        local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
        if g:GetCount()>0 then
            local sc=g:GetFirst()
            while sc do
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_ATTACK)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                e1:SetValue(-1000)
                sc:RegisterEffect(e1)
                sc=g:GetNext()
            end
        end
    elseif d2 == 2 then
        local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
        if g:GetCount()>0 then
            local sc=g:GetFirst()
            while sc do
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_ATTACK)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                e1:SetValue(1000)
                sc:RegisterEffect(e1)
                sc=g:GetNext()
            end
        end
    elseif d2 == 3 then
        local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
        if g:GetCount()>0 then
            local sc=g:GetFirst()
            while sc do
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_ATTACK)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                e1:SetValue(-500)
                sc:RegisterEffect(e1)
                sc=g:GetNext()
            end
        end
    elseif d2 == 4 then
        local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
        if g:GetCount()>0 then
            local sc=g:GetFirst()
            while sc do
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_ATTACK)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                e1:SetValue(500)
                sc:RegisterEffect(e1)
                sc=g:GetNext()
            end
        end
    elseif d2 == 5 then
        local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
        if g:GetCount()>0 then
            local sc=g:GetFirst()
            while sc do
                local atk=sc:GetAttack()
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_SET_ATTACK_FINAL)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                e1:SetValue(math.ceil(atk/2))
                sc:RegisterEffect(e1)
                sc=g:GetNext()
            end
        end
    elseif d2 == 6 then
        local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
        if g:GetCount()>0 then
            local sc=g:GetFirst()
            while sc do
                local atk=sc:GetAttack()
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_SET_ATTACK_FINAL)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
                e1:SetValue(atk*2)
                sc:RegisterEffect(e1)
                sc=g:GetNext()
            end
        end
    else
        return
    end
end