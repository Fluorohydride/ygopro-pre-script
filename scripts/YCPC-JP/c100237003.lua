--農園からの配送

--Script by nekrozar
function c100237003.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c100237003.condition)
	e1:SetTarget(c100237003.target)
	e1:SetOperation(c100237003.activate)
	c:RegisterEffect(e1)
end
function c100237003.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
end
function c100237003.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100237003.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100237003.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL) and c:IsAbleToDeck()
end
function c100237003.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVE) and chkc:IsControler(tp) and c100237003.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100237003.filter,tp,LOCATION_REMOVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c100237003.filter,tp,LOCATION_REMOVE,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c100237003.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
