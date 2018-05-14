--ビンゴマシーンGO!GO!
--Bingo Machine GO! GO!
--Script by dest
function c100409003.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100409003+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100409003.thtg)
	e1:SetOperation(c100409003.thop)
	c:RegisterEffect(e1)
end
c100409003.card_code_list={89631139,23995346}
function c100409003.thfilter(c)
	return (((aux.IsCodeListed(c,89631139) or aux.IsCodeListed(c,23995346)) and not c:IsCode(100409003) and c:IsType(TYPE_SPELL+TYPE_TRAP))
		or (c:IsSetCard(0xdd) and c:IsType(TYPE_MONSTER))) and c:IsAbleToHand()
end
function c100409003.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100409003.thfilter,tp,LOCATION_DECK,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100409003.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100409003.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,3,3,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tg=sg:RandomSelect(1-tp,1)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
