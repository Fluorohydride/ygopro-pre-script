--命运之抽卡
--Script by Djeeta
function c100236003.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100236003)
	e1:SetCondition(c100236003.condition)
	e1:SetTarget(c100236003.target)
	e1:SetOperation(c100236003.activate)
	c:RegisterEffect(e1)    
end
function c100236003.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return false end
	local tg=g:GetMaxGroup(Card.GetAttack)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tg:IsExists(Card.IsControler,1,nil,1-tp) and Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c100236003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_DECK,0,3,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c100236003.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local sg=g:Select(tp,3,3,nil)
		Duel.ConfirmCards(1-tp,sg)
		if Duel.ShuffleDeck(tp)~=0 then
			for i=1,3 do
				local tc
				if i<3 then
					tc=sg:RandomSelect(tp,1):GetFirst()
				else
					tc=sg:GetFirst()
				end
				Duel.MoveSequence(tc,0)
				sg:RemoveCard(tc)
			end
		end
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SSET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c100236003.regcon)
	e2:SetOperation(c100236003.regop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetTargetRange(1,0)
	e3:SetCondition(c100236003.actcon)
	e3:SetValue(1)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c100236003.regcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c100236003.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,100236003,RESET_PHASE+PHASE_END,0,1)
end
function c100236003.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,100236003)>0
end
