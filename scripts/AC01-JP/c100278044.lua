--機塊コンバート

--Script by Chrono-Genex
function c100278044.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c100278044.condition)
	e1:SetTarget(c100278044.target)
	e1:SetOperation(c100278044.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100278044,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100278044)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c100278044.thcost)
	e2:SetTarget(c100278044.thtg)
	e2:SetOperation(c100278044.thop)
	c:RegisterEffect(e2)
end
function c100278044.filter(c)
	return c:IsSetCard(0x14b) and c:IsType(TYPE_LINK) and c:GetSequence()<5 and c:IsAbleToRemove()
end
function c100278044.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100278044.filter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c100278044.filter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c100278044.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x14b) and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100278044.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100278044.filter,tp,LOCATION_MZONE,0,nil)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		local ct=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED):GetCount()
		local sg=Duel.GetMatchingGroup(c100278044.spfilter,tp,LOCATION_REMOVED,0,nil,e,tp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ct>0 and sg:GetCount()>0 and ft>0 and Duel.SelectYesNo(tp,aux.Stringid(100278044,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=sg:Select(tp,1,ct,nil)
			Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c100278044.costfilter(c)
	return c:IsSetCard(0x14b) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function c100278044.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c100278044.costfilter,tp,LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c100278044.costfilter,tp,LOCATION_GRAVE,0,1,1,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c100278044.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c100278044.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
