--マジシャンズ・ロッド
--Magician's Rod
--Script by dest
--e1 needs updated files from https://github.com/Fluorohydride/ygopro-scripts/pull/273 in order to work
function c100909019.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100909019,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,100909019)
	e1:SetTarget(c100909019.thtg)
	e1:SetOperation(c100909019.thop)
	c:RegisterEffect(e1)
	--tohand (self)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100909019,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,100909119)
	e2:SetCondition(c100909019.condition)
	e2:SetCost(c100909019.cost)
	e2:SetTarget(c100909019.target)
	e2:SetOperation(c100909019.operation)
	c:RegisterEffect(e2)
end
function c100909019.thfilter(c)
	return c.dark_magician_list and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c100909019.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100909019.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100909019.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100909019.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100909019.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and ep==tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c100909019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsRace,1,nil,RACE_SPELLCASTER) end
	local sg=Duel.SelectReleaseGroup(tp,Card.IsRace,1,1,nil,RACE_SPELLCASTER)
	Duel.Release(sg,REASON_COST)
end
function c100909019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c100909019.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
