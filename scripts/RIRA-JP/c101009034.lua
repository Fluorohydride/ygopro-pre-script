--魂の造形家
--
--Script by mercury233
function c101009034.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101009034,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101009034)
	e1:SetCost(c101009034.thcost)
	e1:SetTarget(c101009034.thtg)
	e1:SetOperation(c101009034.thop)
	c:RegisterEffect(e1)
end
function c101009034.cfilter(c,tp)
	local sum=math.max(c:GetTextAttack(),0)+math.max(c:GetTextDefense(),0)
	return c:IsAttackAbove(0) and c:IsDefenseAbove(0)
		and Duel.IsExistingMatchingCard(c101009034.thfilter,tp,LOCATION_DECK,0,1,nil,sum)
end
function c101009034.thfilter(c,csum)
	local sum=math.max(c:GetTextAttack(),0)+math.max(c:GetTextDefense(),0)
	return c:IsAttackAbove(0) and c:IsDefenseAbove(0) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and csum==sum
end
function c101009034.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101009034.cfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c101009034.cfilter,1,1,nil,tp)
	local sum=math.max(g:GetFirst():GetTextAttack(),0)+math.max(g:GetFirst():GetTextDefense(),0)
	e:SetLabel(sum)
	Duel.Release(g,REASON_COST)
end
function c101009034.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101009034.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101009034.thfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
