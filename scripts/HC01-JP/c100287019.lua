--ライディング・デュエル!アクセラレーション!
--
--Script by Trishula9
function c100287019.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100287019+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c100287019.activate)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c100287019.ctcon)
	e2:SetTarget(c100287019.cttg)
	e2:SetOperation(c100287019.ctop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c100287019.drcost)
	e3:SetTarget(c100287019.drtg)
	e3:SetOperation(c100287019.drop)
	c:RegisterEffect(e3)
end
function c100287019.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1017) and c:IsAbleToHand()
end
function c100287019.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) then return end
	local g=Duel.GetMatchingGroup(c100287019.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(100287019,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c100287019.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c100287019.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x104d,1) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x104d)
end
function c100287019.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x104d,1)
	end
end
function c100287019.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x104d,2,REASON_COST)
		and e:GetHandler():IsAbleToGraveAsCost() end
	Duel.RemoveCounter(tp,1,0,0x104d,2,REASON_COST)
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c100287019.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c100287019.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==2 then
		Duel.ShuffleHand(p)
		Duel.BreakEffect()
		Duel.DiscardHand(p,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
