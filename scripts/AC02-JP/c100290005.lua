--ダイス・ダンジョン
--
--Script by Trishula9
function c100290005.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c100290005.activate)
	c:RegisterEffect(e1)
	--dice
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DICE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c100290005.dctg)
	e2:SetOperation(c100290005.dcop)
	c:RegisterEffect(e2)
end
c100290005.toss_dice=true
function c100290005.filter(c)
	return c:IsCode(100290006) and c:IsAbleToHand()
end
function c100290005.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100290005.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(100290005,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c100290005.dctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,PLAYER_ALL,1)
end
function c100290005.dcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d1,d2=Duel.TossDice(tp,1,1)
	table={d1,d2}
	p=0
	for i=1,2 do
		if i==1 then p=tp else p=1-tp end
		local g=Duel.GetMatchingGroup(Card.IsFaceup,p,LOCATION_MZONE,0,nil)
		if g:GetCount()>0 then
			local d=table[i]
			local sc=g:GetFirst()
			while sc do
				if d==1 then ct=-1000
				elseif d==2 then ct=1000
				elseif d==3 then ct=-500
				elseif d==4 then ct=500
				elseif d==5 then ct=-sc:GetAttack()/2
				elseif d==6 then ct=sc:GetAttack()
				else return end
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				e1:SetValue(ct)
				sc:RegisterEffect(e1)
				sc=g:GetNext()
			end
		end
	end
end