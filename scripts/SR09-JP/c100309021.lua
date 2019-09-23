--武装鍛錬

--Scripted by nekrozar
function c100309021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100309021,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,100309021)
	e2:SetCondition(c100309021.thcon)
	e2:SetTarget(c100309021.thtg)
	e2:SetOperation(c100309021.thop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100309021,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,100309121)
	e3:SetCondition(c100309021.drcon)
	e3:SetCost(c100309021.drcost)
	e3:SetTarget(c100309021.drtg)
	e3:SetOperation(c100309021.drop)
	c:RegisterEffect(e3)
end
function c100309021.thcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetDrawCount(tp)>0
end
function c100309021.thfilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c100309021.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100309021.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		_replace_count=0
		_replace_max=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK+LOCATION_GRAVE)
end
function c100309021.thop(e,tp,eg,ep,ev,re,r,rp)
	_replace_count=_replace_count+1
	if _replace_count>_replace_max or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100309021.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100309021.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP)
end
function c100309021.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100309021.cfilter,tp,LOCATION_SZONE,0,1,nil)
end
function c100309021.costfilter(c)
	return ((c:IsAttribute(ATTRIBUTE_FIRE) and c:IsRace(RACE_WARRIOR)) or c:IsType(TYPE_DUAL)) and c:IsAbleToDeckAsCost()
end
function c100309021.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100309021.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c100309021.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function c100309021.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c100309021.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
