--ペンデュラム・トレジャー
--
--Script by XyLeN
function c101105068.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101105068+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101105068.target)
	e1:SetOperation(c101105068.activate)
	c:RegisterEffect(e1)
end
function c101105068.filter(c)
	return c:IsType(TYPE_PENDULUM)
end
function c101105068.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101105068.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c101105068.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101105068,0))
	local g=Duel.SelectMatchingCard(tp,c101105068.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,tp,REASON_EFFECT)
	end
end
