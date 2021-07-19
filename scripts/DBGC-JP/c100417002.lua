--Ga－P.U.N.K.ワゴン
--
--scripted by XyLeN
function c100417002.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100417002,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100417002)
	e1:SetCost(c100417002.thcost)
	e1:SetTarget(c100417002.thtg)
	e1:SetOperation(c100417002.thop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100417002,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100417002+100)
	e2:SetCondition(c100417002.drcon1)
	e2:SetTarget(c100417002.drtg)
	e2:SetOperation(c100417002.drop)
	c:RegisterEffect(e2)
	local e3=e2:Clone() 
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetCondition(c100417002.drcon2)
	c:RegisterEffect(e3)
end
function c100417002.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,600) end
	Duel.PayLPCost(tp,600)
end
function c100417002.thfilter(c)
	return c:IsSetCard(0x26f) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c100417002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100417002.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100417002.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100417002.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100417002.drcon1(e,tp,eg,ep,ev,re,r,rp)
	local bc=eg:GetFirst()
	return bc:IsSetCard(0x26f) and bc:IsControler(tp)
end
function c100417002.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x26f)
end
function c100417002.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and eg:IsExists(c100417002.cfilter,1,nil,tp)
end
function c100417002.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c100417002.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end