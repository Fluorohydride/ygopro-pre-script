--暗黒の招来神

--Scripted by mallu11
function c100338003.initial_effect(c)
	aux.AddCodeList(c,6007213,32491822,69890967)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100338003,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,100338003)
	e1:SetTarget(c100338003.thtg)
	e1:SetOperation(c100338003.thop)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100338003,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetTarget(c100338003.exstg)
	c:RegisterEffect(e2)
end
function c100338003.thfilter(c)
	return (c:IsCode(6007213,32491822,69890967)
		or ((aux.IsCodeListed(c,6007213) or aux.IsCodeListed(c,32491822) or aux.IsCodeListed(c,69890967))
		and not c:IsCode(100338003))) and c:IsAbleToHand()
end
function c100338003.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100338003.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100338003.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100338003.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100338003.exstg(e,c)
	return c:IsRace(RACE_FIEND) and c:IsAttack(0) and c:IsDefense(0)
end
