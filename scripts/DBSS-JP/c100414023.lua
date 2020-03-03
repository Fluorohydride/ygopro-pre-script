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
end
function c100414023.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c100414023.thfilter(c,check)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x245) and c:IsAbleToHand() and (check or Duel.IsExistingMatchingCard(c100414023.thfilter2,tp,LOCATION_DECK,0,1,c,c:GetCode(),c:GetOriginalLevel()))
end
function c100414023.thfilter2(c,code,lv)
	return c:IsRace(RACE_PLANT) and not c:IsCode(code) and c:GetOriginalLevel()==lv and c:IsAbleToHand()
end
function c100414023.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c100414023.thfilter,tp,LOCATION_DECK,0,1,nil,true)
	local b2=Duel.IsExistingMatchingCard(c100414023.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.CheckReleaseGroup(tp,Card.IsRace,1,nil,RACE_PLANT)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return b1 or b2
	end
	if b2 and (not b1 or Duel.SelectOption(tp,aux.Stringid(100414023,1),aux.Stringid(100414023,2))==1) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectReleaseGroup(tp,Card.IsRace,1,1,nil,RACE_PLANT)
		Duel.Release(g,REASON_COST)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
	else
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
	e:SetLabel(0)
end
function c100414023.activate(e,tp,eg,ep,ev,re,r,rp)
	local param=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local check=nil
	if param==1 then
		check=false
	else
		check=true
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100414023.thfilter,tp,LOCATION_DECK,0,1,1,nil,true)
	local tc=g:GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tc)
		if not check and tc:IsLocation(LOCATION_HAND) and Duel.IsExistingMatchingCard(c100414023.thfilter2,tp,LOCATION_DECK,0,1,nil,tc:GetCode(),tc:GetOriginalLevel()) then
			Duel.BreakEffect()
			local tg=Duel.SelectMatchingCard(tp,c100414023.thfilter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode(),tc:GetOriginalLevel())
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
