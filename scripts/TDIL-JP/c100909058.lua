--イリュージョン・マジック
--Illusion Magic
--ygohack137-13790911
function c100909058.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100909058+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c100909058.cost)
	e1:SetTarget(c100909058.target)
	e1:SetOperation(c100909058.activate)
	c:RegisterEffect(e1)
end
c100909058.dark_magician_list=true
function c100909058.cfilter(c)
	return c:IsRace(RACE_SPELLCASTER)
end
function c100909058.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c100909058.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c100909058.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c100909058.filter(c)
	return c:IsCode(46986414) and c:IsAbleToHand()
end
function c100909058.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100909058.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c100909058.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100909058.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

