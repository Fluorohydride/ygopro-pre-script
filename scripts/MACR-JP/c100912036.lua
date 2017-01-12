--灰流うらら
--Ghost Ash & Beautiful Spring
--Script by dest
function c100912036.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100912036)
	e1:SetCondition(c100912036.discon)
	e1:SetCost(c100912036.discost)
	e1:SetTarget(c100912036.distg)
	e1:SetOperation(c100912036.disop)
	c:RegisterEffect(e1)
end
function c100912036.discon(e,tp,eg,ep,ev,re,r,rp)
	local ex1,g1,gc1,dp1,dv1=Duel.GetOperationInfo(ev,CATEGORY_TOHAND)
	local ex2,g2,gc2,dp2,dv2=Duel.GetOperationInfo(ev,CATEGORY_SPECIAL_SUMMON)
	local ex3,g3,gc3,dp3,dv3=Duel.GetOperationInfo(ev,CATEGORY_TOGRAVE)
	return ep~=tp and ((ex1 and dv1==LOCATION_DECK) or (ex2 and dv2==LOCATION_DECK)
		or (ex3 and dv3==LOCATION_DECK)) and Duel.IsChainDisablable(ev)
end
function c100912036.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c100912036.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c100912036.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
