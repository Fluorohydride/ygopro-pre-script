--Vendread Battlelord
--Scripted by Eerie Code
function c101003082.initial_effect(c)
	c:EnableReviveLimit()
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101003082,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,101003082)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c101003082.cost)
	e1:SetTarget(c101003082.target)
	e1:SetOperation(c101003082.operation)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101003082,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,101003082+100)
	e2:SetCondition(c101003082.thcon)
	e2:SetTarget(c101003082.thtg)
	e2:SetOperation(c101003082.thop)
	c:RegisterEffect(e2)
end
function c101003082.cfilter(c)
	return c:IsSetCard(0x106) and c:IsAbleToRemoveAsCost()
end
function c101003082.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101003082.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101003082.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101003082.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	e:SetLabel(Duel.AnnounceType(tp))
end
function c101003082.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	if e:GetLabel()==0 then
		e1:SetDescription(aux.Stringid(101003082,2))
		e1:SetValue(c101003082.aclimit1)
	elseif e:GetLabel()==1 then
		e1:SetDescription(aux.Stringid(101003082,3))
		e1:SetValue(c101003082.aclimit2)
	else
		e1:SetDescription(aux.Stringid(101003082,4))
		e1:SetValue(c101003082.aclimit3)
	end
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101003082.aclimit1(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end
function c101003082.aclimit2(e,re,tp)
	return re:IsActiveType(TYPE_SPELL) and not re:GetHandler():IsImmuneToEffect(e)
end
function c101003082.aclimit3(e,re,tp)
	return re:IsActiveType(TYPE_TRAP) and not re:GetHandler():IsImmuneToEffect(e)
end
function c101003082.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function c101003082.thfilter(c,tp)
	return bit.band(c:GetType(),TYPE_RITUAL+TYPE_MONSTER)==TYPE_RITUAL+TYPE_MONSTER and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c101003082.tgfilter,tp,LOCATION_DECK,0,1,c)
end
function c101003082.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x106) and c:IsAbleToGrave()
end
function c101003082.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101003082.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c101003082.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local hg=Duel.SelectMatchingCard(tp,c101003082.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if hg:GetCount()>0 and Duel.SendtoHand(hg,tp,REASON_EFFECT)>0
		and hg:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c101003082.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
