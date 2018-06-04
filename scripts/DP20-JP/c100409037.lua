--フォトン・ハンド
--Photon Hand
--Script by dest
function c100409037.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100409037+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100409037.condition)
	e1:SetCost(c100409037.cost)
	e1:SetTarget(c100409037.target)
	e1:SetOperation(c100409037.activate)
	c:RegisterEffect(e1)
end
function c100409037.cfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x55) or c:IsSetCard(0x7b))
end
function c100409037.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100409037.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100409037.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c100409037.geffilter(c)
	return c:IsFaceup() and c:IsCode(93717133)
end
function c100409037.filter(c,tp)
	return (Duel.IsExistingMatchingCard(c100409037.geffilter,tp,LOCATION_ONFIELD,0,1,nil)
		or (c:IsFaceup() and c:IsType(TYPE_XYZ))) and c:IsControlerCanBeChanged()
end
function c100409037.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c100409037.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c100409037.filter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c100409037.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c100409037.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
	end
end
