--天空聖騎士アークパーシアス
--Angel Paladin Arch-Parshath
--Scripted by sahim
function c100305001.initial_effect(c)
	--counter activated
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100305001,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCondition(c100305001.cntCon)
	e1:SetCost(c100305001.cost)
	e1:SetTarget(c100305001.tg)
	e1:SetOperation(c100305001.op)
	c:RegisterEffect(e1)
	--effect negated
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetCondition(c100305001.negCon)
	c:RegisterEffect(e2)
	--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100305001,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetCondition(c100305001.thcon)
	e4:SetTarget(c100305001.thtg)
	e4:SetOperation(c100305001.thop)
	c:RegisterEffect(e4)
end
function c100305001.cntCon(e,tp,eg,ep,ev,re,r,rp,chk)
	return re:GetHandler():IsType(TYPE_COUNTER) and re:GetHandlerPlayer()==tp 
end
function c100305001.negCon(e,tp,eg,ep,ev,re,r,rp,chk)
	local de,dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON,CHAININFO_DISABLE_PLAYER)
	return dp==tp 
end
function c100305001.filter(c)
	return c:IsRace(RACE_FAIRY) and c:IsAbleToRemoveAsCost()
end
function c100305001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100305001.filter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c100305001.filter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,2,2,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c100305001.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100305001.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100305001.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c100305001.thfil(c)
	return (c:IsSetCard(0x208) or c:IsCode(18036057,69514125,76925842,12510878) or c:IsType(TYPE_COUNTER)) and c:IsAbleToHand()
end
function c100305001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100305001.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100305001.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100305001.thfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
