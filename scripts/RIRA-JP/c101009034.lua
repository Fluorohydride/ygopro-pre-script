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
function c101009034.getsum(c)
	local atk=c:GetTextAttack()
	if atk<0 then atk=0 end
	local def=c:GetTextDefense()
	if def<0 then def=0 end
	return atk+def
end
function c101009034.cfilter(c,tp)
	return c:IsDefenseAbove(0)
		and Duel.IsExistingMatchingCard(c101009034.thfilter,tp,LOCATION_DECK,0,1,nil,c101009034.getsum(c))
end
function c101009034.thfilter(c,sum)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c101009034.getsum(c)==sum
end
function c101009034.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101009034.cfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c101009034.cfilter,1,1,nil,tp)
	e:SetLabel(c101009034.getsum(g:GetFirst()))
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
