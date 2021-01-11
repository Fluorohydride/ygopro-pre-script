--ワン・バイ・ワン
--One by One
--Scripted by Kohana Sonogami
function c101104078.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101104078+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c101104078.cost)
	e1:SetTarget(c101104078.target)
	e1:SetOperation(c101104078.operation)
	c:RegisterEffect(e1)
end
function c101104078.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c101104078.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101104078.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101104078.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c101104078.thfilter(c)
	return c:IsLevel(1) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToHand()
end
function c101104078.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c101104078.thfilter(chkc) and chkc~=e:GetLabelObject() end
	if chk==0 then return Duel.IsExistingTarget(c101104078.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101104078.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,e:GetLabelObject())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101104078.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
