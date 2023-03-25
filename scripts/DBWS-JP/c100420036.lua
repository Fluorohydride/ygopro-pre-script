--Voici la Carte～メニューはこちら～
--scripted by JoyJ
function c100420036.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,100420036+EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100420036.target)
	e1:SetOperation(c100420036.activate)
	c:RegisterEffect(e1)
end
function c100420036.filter(c)
	return c:IsSetCard(0x196) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c100420036.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c100420036.filter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>1 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100420036.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c100420036.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100420036.filter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	Duel.ConfirmCards(1-tp,sg)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	local tc=sg:Select(1-tp,1,1,nil):GetFirst()
	local code=0
	if tc:IsRace(RACE_BEASTWARRIOR) then code=100420037 end
	if tc:IsRace(RACE_WARRIOR) then code=100420038 end
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100420036.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,code)
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsRace(RACE_BEASTWARRIOR+RACE_WARRIOR)
		and #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(100420036,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.SendtoHand(sg2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg2)
	end
end
