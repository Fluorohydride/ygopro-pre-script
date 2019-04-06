--妖仙獣の風祀り
--
--Script by mercury233
function c101009057.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101009057+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101009057.condition)
	e1:SetTarget(c101009057.target)
	e1:SetOperation(c101009057.activate)
	c:RegisterEffect(e1)
end
function c101009057.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xb3) and c:GetOriginalType()&TYPE_MONSTER~=0
end
function c101009057.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101009057.cfilter,tp,LOCATION_ONFIELD,0,nil)
	return g:GetClassCount(Card.GetCode)>=3
end
function c101009057.filter(c)
	return c101009057.cfilter(c) and c:IsAbleToHand()
end
function c101009057.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101009057.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.GetMatchingGroup(c101009057.filter,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c101009057.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c101009057.filter,tp,LOCATION_ONFIELD,0,nil)
	if Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 then
		local ct=5-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		if ct>0 and Duel.IsPlayerCanDraw(tp,ct)
			and Duel.SelectYesNo(tp,aux.Stringid(101009057,0)) then
			Duel.BreakEffect()
			Duel.Draw(tp,ct,REASON_EFFECT)
		end
	end
end
