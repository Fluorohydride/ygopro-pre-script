--煉獄の災天

--Scripted by mallu11
function c101012065.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to grave1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101012065,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,101012065)
	e2:SetCost(c101012065.tgcost1)
	e2:SetTarget(c101012065.tgtg1)
	e2:SetOperation(c101012065.tgop1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(101012065,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetCost(c101012065.tgcost2)
	e3:SetTarget(c101012065.tgtg2)
	e3:SetOperation(c101012065.tgop2)
	c:RegisterEffect(e3)
end
function c101012065.tgcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c101012065.filter1(c)
	return c:IsRace(RACE_FIEND) and c:IsAbleToGrave()
end
function c101012065.tgtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101012065.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c101012065.tgop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101012065.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c101012065.tgcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c101012065.filter2(c)
	return c:IsSetCard(0xbb) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c101012065.exfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function c101012065.tgtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c101012065.exfilter,tp,0,LOCATION_MZONE,nil)
	local g=Duel.GetMatchingGroup(c101012065.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	if chk==0 then return ct>0 and g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c101012065.tgop2(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c101012065.exfilter,tp,0,LOCATION_MZONE,nil)
	if ct<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.GetMatchingGroup(c101012065.filter2,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
