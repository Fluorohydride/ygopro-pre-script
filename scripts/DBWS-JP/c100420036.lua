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
	return c:IsSetCard(0x293) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
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
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	local tc=sg:Select(1-tp,1,1,nil):GetFirst()
	local code=0
	if tc:IsRace(RACE_BEASTWARRIOR) then code=100420037 end
	if tc:IsRace(RACE_WARRIOR) then code=100420038 end
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsRace(RACE_BEASTWARRIOR+RACE_WARRIOR)
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c100420036.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,code)
		and Duel.SelectYesNo(tp,aux.Stringid(100420036,1)) then
		Duel.BreakEffect()
		g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100420036.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,code)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end