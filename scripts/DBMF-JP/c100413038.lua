--王の支配

--Scripted by nekrozar
function c100413038.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100413038.target)
	e1:SetOperation(c100413038.activate)
	c:RegisterEffect(e1)
	--change effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100413038,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,100413038)
	e2:SetCondition(c100413038.chcon)
	e2:SetCost(c100413038.chcost)
	e2:SetTarget(c100413038.chtg)
	e2:SetOperation(c100413038.chop)
	c:RegisterEffect(e2)
end
function c100413038.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(0)
	local ct=Duel.GetCurrentChain()
	if ct<=2 then return end
	local te=Duel.GetChainInfo(ct-2,CHAININFO_TRIGGERING_EFFECT)
	if te and te:GetHandler():IsSetCard(0x232) and rp==1-tp
		and c100413038.chcost(e,tp,eg,ep,ev,re,r,rp,0)
		and c100413038.chtg(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,94) then
		e:SetLabel(1)
		e:SetCategory(CATEGORY_DRAW)
		c100413038.chcost(e,tp,eg,ep,ev,re,r,rp,1)
		c100413038.chtg(e,tp,eg,ep,ev,re,r,rp,1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
		e:GetHandler():RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(100413038,2))
	end
end
function c100413038.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()~=1 then return end
	local ct=Duel.GetChainInfo(0,CHAININFO_CHAIN_COUNT)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ct-1,g)
	Duel.ChangeChainOperation(ct-1,c100413038.repop)
end
function c100413038.chcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCurrentChain()
	if ct==1 then return end
	local te=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT)
	return te and te:GetHandler():IsSetCard(0x232) and rp==1-tp
end
function c100413038.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c100413038.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c100413038.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c100413038.repop)
end
function c100413038.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end
