--走魔灯
--
--Script by Trishula9
function c101107080.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCondition(c101107080.condition)
	e1:SetTarget(c101107080.target)
	e1:SetOperation(c101107080.operation)
	c:RegisterEffect(e1)
end
function c101107080.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<100
end
function c101107080.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c101107080.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 and Duel.GetLP(p)<10 then
		Duel.Draw(p,2,REASON_EFFECT)
	end
end
