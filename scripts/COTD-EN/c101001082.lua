--Revendread Slayer
--Scripted by Eerie Code
function c101001082.initial_effect(c)
	c:EnableReviveLimit()
	--atk & def
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101001082,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c101001082.atkcon)
	e1:SetCost(c101001082.atkcost)
	e1:SetOperation(c101001082.atkop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101001082,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,101001082)
	e2:SetCondition(c101001082.thcon)
	e2:SetTarget(c101001082.thtg)
	e2:SetOperation(c101001082.thop)
	c:RegisterEffect(e2)
end
function c101001082.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattleTarget()~=nil
end
function c101001082.atkcfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsAbleToRemoveAsCost()
end
function c101001082.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(101001082)==0
		and Duel.IsExistingMatchingCard(c101001082.atkcfilter,tp,LOCATION_GRAVE,0,1,nil) end
	c:RegisterFlagEffect(101001082,RESET_CHAIN,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101001082.atkcfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101001082.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(300)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
function c101001082.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function c101001082.thfilter(c)
	return c:GetType()==TYPE_RITUAL+TYPE_SPELL and c:IsAbleToHand()
end
function c101001082.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x209) and c:IsAbleToGrave()
end
function c101001082.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101001082.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c101001082.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c101001082.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local hg=Duel.SelectMatchingCard(tp,c101001082.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if hg:GetCount()>0 and Duel.SendtoHand(hg,tp,REASON_EFFECT)>0
		and hg:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c101001082.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
