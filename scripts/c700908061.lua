--真竜の目覚め
--True Draco-Awakening
--Script by mercury233
function c700908061.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c700908061.condition)
	e1:SetTarget(c700908061.target)
	e1:SetOperation(c700908061.activate)
	c:RegisterEffect(e1)
end
function c700908061.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xda)
end
function c700908061.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0xc7) and not c:IsType(TYPE_PENDULUM)
end
function c700908061.filter3(c,e,tp)
	return (c:IsSetCard(0xda) or c:IsSetCard(0xc7)) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c700908061.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c700908061.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c700908061.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c700908061.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c700908061.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0
		and Duel.IsExistingMatchingCard(c700908061.filter3,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,509) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c700908061.filter3,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end
