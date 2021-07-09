--烙印の気炎
--
--Script by mercury233
function c101106055.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101106055,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_HANDES+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101106055)
	e1:SetTarget(c101106055.target)
	e1:SetOperation(c101106055.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101106055,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1,101106055)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c101106055.thcon)
	e2:SetTarget(c101106055.thtg)
	e2:SetOperation(c101106055.thop)
	c:RegisterEffect(e2)
	if not c101106055.global_check then
		c101106055.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c101106055.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c101106055.checkfilter(c,tp)
	return c:IsType(TYPE_FUSION) and c:IsControler(tp)
end
function c101106055.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c101106055.checkfilter,1,nil,0) then Duel.RegisterFlagEffect(0,101106055,RESET_PHASE+PHASE_END,0,1) end
	if eg:IsExists(c101106055.checkfilter,1,nil,1) then Duel.RegisterFlagEffect(1,101106055,RESET_PHASE+PHASE_END,0,1) end
end
function c101106055.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and not c:IsPublic()
		and Duel.IsExistingMatchingCard(c101106055.tgfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetRace())
end
function c101106055.tgfilter(c,race)
	return (c:IsAttack(2500) or c:IsDefense(2500)) and c:IsRace(race)
		and c:IsLevel(8) and c:IsType(TYPE_FUSION) and c:IsAbleToGrave()
end
function c101106055.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101106055.cfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c101106055.thfilter(c)
	return (c:IsCode(68468459) or aux.IsCodeListed(c,68468459) and c:IsType(TYPE_MONSTER)) and c:IsAbleToHand()
end
function c101106055.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c101106055.cfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	local cc=g:GetFirst()
	if cc then
		Duel.ConfirmCards(1-tp,cc)
		local race=cc:GetRace()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,c101106055.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil,race)
		local tc=tg:GetFirst()
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
			local g=Duel.GetMatchingGroup(c101106055.thfilter,tp,LOCATION_DECK,0,nil)
			if #g>0 and cc:IsDiscardable() and Duel.SelectYesNo(tp,aux.Stringid(101106055,2)) then
				Duel.BreakEffect()
				Duel.SendtoGrave(cc,REASON_EFFECT+REASON_DISCARD)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g:Select(tp,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
		end
	end
end
function c101106055.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,101106055)~=0
end
function c101106055.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c101106055.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
