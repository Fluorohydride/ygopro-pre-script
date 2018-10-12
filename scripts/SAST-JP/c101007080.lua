--ロスタイム

--Script by nekrozar
function c101007080.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101007080+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101007080.condition)
	e1:SetOperation(c101007080.activate)
	c:RegisterEffect(e1)
end
function c101007080.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(1-tp)>=4000 and Duel.GetLP(tp)~=Duel.GetLP(1-tp)-1000
end
function c101007080.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(1-tp)>=4000 and Duel.GetLP(tp)~=Duel.GetLP(1-tp)-1000 then
		Duel.SetLP(tp,Duel.GetLP(1-tp)-1000)
	end
end
