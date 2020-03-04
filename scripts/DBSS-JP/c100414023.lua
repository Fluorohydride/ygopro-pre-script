--六花絢爛

--Scripted by mallu11
function c100414023.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100414023,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100414023+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c100414023.cost)
	e1:SetTarget(c100414023.target)
	e1:SetOperation(c100414023.activate)
	c:RegisterEffect(e1)
	--cost
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100414023,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,100414023+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c100414023.cost)
	e2:SetTarget(c100414023.target2)
	e2:SetOperation(c100414023.activate2)
	c:RegisterEffect(e2)
end
function c100414023.thfilter(c,check)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x245) and c:IsAbleToHand()
		and (check or Duel.IsExistingMatchingCard(c100414023.thfilter2,tp,LOCATION_DECK,0,1,c,c:GetCode(),c:GetOriginalLevel()))
end
function c100414023.thfilter2(c,code,lv)
	return c:IsRace(RACE_PLANT) and not c:IsCode(code) and c:GetOriginalLevel()==lv and c:IsAbleToHand()
end
function c100414023.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100414023.thfilter,tp,LOCATION_DECK,0,1,nil,true) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100414023.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100414023.thfilter,tp,LOCATION_DECK,0,1,1,nil,true)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c100414023.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsRace,1,nil,RACE_PLANT) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,Card.IsRace,1,1,nil,RACE_PLANT)
	Duel.Release(g,REASON_COST)
end
function c100414023.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE)
		and Duel.IsExistingMatchingCard(c100414023.thfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c100414023.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100414023.thfilter,tp,LOCATION_DECK,0,1,1,nil,true)
	local tc=g:GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tc)
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) and tc:IsLocation(LOCATION_HAND)
			and Duel.IsExistingMatchingCard(c100414023.thfilter2,tp,LOCATION_DECK,0,1,nil,tc:GetCode(),tc:GetOriginalLevel()) then
			Duel.BreakEffect()
			local tg=Duel.SelectMatchingCard(tp,c100414023.thfilter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode(),tc:GetOriginalLevel())
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
