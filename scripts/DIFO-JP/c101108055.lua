--セリオンズ・チャージ
--
--Script by JustFish
function c101108055.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101108055+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c101108055.cost)
	e1:SetTarget(c101108055.target)
	e1:SetOperation(c101108055.activate)
	c:RegisterEffect(e1)
end
function c101108055.costfilter(c)
	return (c:IsSetCard(0x27a) or c:IsCode(101108054)) and ((c:IsFaceup() and c:GetSequence()<5) or not c:IsLocation(LOCATION_SZONE)) and not c:IsCode(101108055) and c:IsAbleToGraveAsCost()
end
function c101108055.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101108055.costfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101108055.costfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c101108055.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c101108055.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
