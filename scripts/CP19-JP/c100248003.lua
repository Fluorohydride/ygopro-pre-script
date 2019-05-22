--星の金貨
--
--Scripted by 龙骑
function c100248003.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100248003+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100248003.target)
	e1:SetOperation(c100248003.activate)
	c:RegisterEffect(e1)
end
function c100248003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,2,e:GetHandler()) and Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c100248003.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100248003,0))
	local ag=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,2,2,nil)
	if ag:GetCount()>0 then
		Duel.SendtoHand(ag,1-tp,REASON_EFFECT)
		Duel.ConfirmCards(tp,ag)
		Duel.ShuffleHand(tp)
		Duel.ShuffleHand(1-tp)
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
