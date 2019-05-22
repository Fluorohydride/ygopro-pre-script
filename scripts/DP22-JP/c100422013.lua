--E－HERO アダスター・ゴールド
--
--Scripted by 龙骑
function c100422013.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100422013)
	e1:SetCost(c100422013.cost)
	e1:SetTarget(c100422013.target)
	e1:SetOperation(c100422013.operation)
	c:RegisterEffect(e1)
	--atklimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetCondition(c100422013.atkcon)
	c:RegisterEffect(e2)
end
c100422013.card_code_list={94820406}
function c100422013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c100422013.filter(c)
	return (aux.IsCodeListed(c,94820406) or c:IsCode(94820406)) and not c:IsCode(100422013) and c:IsAbleToHand()
end
function c100422013.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c100422013.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100422013.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100422013.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100422013.cfilter(c)
	return c:IsType(TYPE_FUSION) and c:IsFaceup()
end
function c100422013.atkcon(e)
	return not Duel.IsExistingMatchingCard(c100422013.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
