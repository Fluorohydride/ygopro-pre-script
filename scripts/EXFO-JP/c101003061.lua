--ペンデュラム・パラドックス
--Pendulum Paradox
--Scripted by Eerie Code
function c101003061.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101003061+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101003061.target)
	e1:SetOperation(c101003061.activate)
	c:RegisterEffect(e1)
end
function c101003061.filter1(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c101003061.filter2,tp,LOCATION_EXTRA,0,1,c,c:GetLeftScale(),c:GetCode())
end
function c101003061.filter2(c,sc,cd)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
		and c:GetLeftScale()==sc and not c:IsCode(cd)
end
function c101003061.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101003061.filter1,tp,LOCATION_EXTRA,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_EXTRA)
end
function c101003061.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc1=Duel.SelectMatchingCard(tp,c101003061.filter1,tp,LOCATION_EXTRA,0,1,1,nil,tp):GetFirst()
	if not tc1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc2=Duel.SelectMatchingCard(tp,c101003061.filter2,tp,LOCATION_EXTRA,0,1,1,tc1,tc1:GetLeftScale(),tc1:GetCode()):GetFirst()
	Duel.SendtoHand(Group.FromCards(tc1,tc2),nil,REASON_EFFECT)
end
