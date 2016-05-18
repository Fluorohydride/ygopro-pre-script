--サイレント・バーニング
--Silent Burning
--Script by mercury233
function c100417004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100417004,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c100417004.condition)
	e1:SetTarget(c100417004.target)
	e1:SetOperation(c100417004.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100417004,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c100417004.thcost)
	e2:SetTarget(c100417004.thtg)
	e2:SetOperation(c100417004.thop)
	c:RegisterEffect(e2)
end
function c100417004.cfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x1e9) or c:IsCode(73665146,72443568))
end
function c100417004.condition(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local ph=Duel.GetCurrentPhase()
	return ct1>ct2 and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
		and Duel.IsExistingMatchingCard(c100417004.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100417004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) and Duel.IsPlayerCanDraw(1-tp) end
	local ht1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ht2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,6-ht1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,6-ht2)
end
function c100417004.activate(e,tp,eg,ep,ev,re,r,rp)
	local ht1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ht2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if ht1<6 then
		Duel.Draw(tp,6-ht1,REASON_EFFECT)
	end
	if ht2<6 then
		Duel.Draw(1-tp,6-ht2,REASON_EFFECT)
	end
end
function c100417004.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c100417004.thfilter(c)
	return (c:IsSetCard(0x1e9) or c:IsCode(73665146,72443568)) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c100417004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100417004.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100417004.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100417004.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
