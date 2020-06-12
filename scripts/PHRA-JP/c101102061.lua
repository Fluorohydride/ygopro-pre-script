--U.A.ハイパー・スタジアム
--U.A. Hyper Stadium
--Scripted by Sock#3222
function c101102061.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,101102061+EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101102061.target)
	e1:SetOperation(c101102061.activate)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101102061,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCost(c101102061.excost)
	e2:SetTarget(c101102061.extg)
	e2:SetOperation(c101102061.exop)
	c:RegisterEffect(e2)
end
function c101102061.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c101102061.thfilter(c)
	if not c:IsAbleToHand() then return false end
	return c:IsLocation(LOCATION_DECK) and (c:IsSetCard(0xb2) or c:IsSetCard(0x107)) and c:IsType(TYPE_MONSTER)
		or c:IsLocation(LOCATION_GRAVE) and c:IsCode(19814508)
end
function c101102061.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c101102061.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	local sel=1
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101102061,0))
	if g:GetCount()>0 then
		sel=Duel.SelectOption(tp,1213,1214)
	else
		sel=Duel.SelectOption(tp,1214)+1
	end
	if sel==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c101102061.cfilter(c)
	return c:IsType(TYPE_FIELD) and not c:IsPublic()
end
function c101102061.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101102061.cfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.CheckLPCost(tp,1000)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c101102061.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.PayLPCost(tp,1000)
end
function c101102061.extg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,101102061)==0
		and Duel.IsPlayerCanSummon(tp) and Duel.IsPlayerCanAdditionalSummon(tp) end
end
function c101102061.exop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(101102061,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(c101102061.estg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,101102061,RESET_PHASE+PHASE_END,0,1)
end
function c101102061.estg(e,c)
	return c:IsSetCard(0xb2) or c:IsSetCard(0x107)
end
