--Scripted by Eerie Code
--Speedroid Pachingo-Kart
function c85034450.initial_effect(c)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(85034450,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c85034450.cost)
	e2:SetTarget(c85034450.target)
	e2:SetOperation(c85034450.operation)
	c:RegisterEffect(e2)
end

function c85034450.cfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsDiscardable()
end
function c85034450.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c85034450.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c85034450.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c85034450.filter(c)
	return c:IsDestructable()
end
function c85034450.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c85034450.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c85034450.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c85034450.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c85034450.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end