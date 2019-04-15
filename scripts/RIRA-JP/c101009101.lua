--極超辰醒

--Script by nekrozar
function c101009101.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101009101+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c101009101.cost)
	e1:SetTarget(c101009101.target)
	e1:SetOperation(c101009101.activate)
	c:RegisterEffect(e1)
end
function c101009101.costfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsType(TYPE_MONSTER)
		and not c:IsSummonableCard() and not c:IsType(TYPE_TOKEN) and c:IsAbleToRemoveAsCost()
end
function c101009101.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101009101.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101009101.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,2,2,nil)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c101009101.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c101009101.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
