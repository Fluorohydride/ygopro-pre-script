--Han-Shi Kyudo Spirit
--Scripted by: XGlitchy30

function c101110032.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101110032,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c101110032.thcon)
	e1:SetTarget(c101110032.thtg)
	e1:SetOperation(c101110032.thop)
	c:RegisterEffect(e1)
	--return + search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101110032,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c101110032.target)
	e2:SetOperation(c101110032.operation)
	c:RegisterEffect(e2)
end
function c101110032.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_PENDULUM)
end
function c101110032.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c101110032.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain(0) then return end
	Duel.SendtoHand(c,nil,REASON_EFFECT)
end

function c101110032.rtfilter(c,tp)
	if not c:IsAbleToHand() then return false end
	return c:IsLocation(LOCATION_PZONE) or c:GetColumnGroup():Filter(Card.IsControler,nil,tp):IsExists(Card.IsLocation,1,nil,LOCATION_PZONE)
end
function c101110032.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c101110032.rtfilter,tp,LOCATION_ONFIELD,0,nil,tp)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,tp,0)
end
function c101110032.thfilter(c)
	return not c:IsCode(101110032) and c:IsType(TYPE_MONSTER) and c:IsAttack(2400) and c:IsDefense(1000) and c:IsAbleToHand()
end
function c101110032.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101110032.rtfilter,tp,LOCATION_ONFIELD,0,nil,tp)
	if #g==0 then return end
	if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) and Duel.IsExistingMatchingCard(c101110032.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(101110032,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c101110032.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #sg>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end