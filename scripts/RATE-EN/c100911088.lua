--SPYRAL GEAR - Utility Wire
--Scripted by Eerie Code
function c100911088.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,100911088+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCondition(c100911088.condition)
	e1:SetTarget(c100911088.target)
	e1:SetOperation(c100911088.activate)
	c:RegisterEffect(e1)
end
function c100911088.cfilter(c)
	return c:IsFaceup() and c:IsCode(41091257)
end
function c100911088.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100911088.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c100911088.filter(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function c100911088.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and c100911088.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100911088.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c100911088.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c100911088.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
	end
end
