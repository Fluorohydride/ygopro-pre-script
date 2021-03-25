--古代遺跡の静粛
--
--scripted by zerovoros a.k.a faultzone
function c101105063.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_MOVE)
	e2:SetCountLimit(1,101105063)
	e2:SetCondition(c101105063.thcon)
	e2:SetTarget(c101105063.thtg)
	e2:SetOperation(c101105063.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_CHAIN_SOLVED)
	c:RegisterEffect(e3)
	--special
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,101105063+100)
	e4:SetCondition(c101105063.spcon)
	e4:SetTarget(c101105063.sptg)
	e4:SetOperation(c101105063.spop)
	c:RegisterEffect(e4)
end
function c101105063.thconfilter(c)
	return c:IsFaceup() and c:IsLocation(LOCATION_FZONE) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_FIELD)
end
function c101105063.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ((eg and eg:IsExists(c101105063.thconfilter,1,nil)) or (re and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_FIELD))) and c:GetFlagEffect(101105063)==0 then
		c:RegisterFlagEffect(101105063,RESET_CHAIN,0,1)
		return true
	end
end
function c101105063.thfilter(c)
	return c:IsSetCard(0xe2) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and not c:IsCode(101105063)
end
function c101105063.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101105063.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101105063.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101105063.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101105063.spconfilter(c,e,tp,eg)
	return (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp))
		and c:GetPreviousRaceOnField()&RACE_ROCK==RACE_ROCK and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
		and Duel.IsExistingMatchingCard(c101105063.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,eg)
end
function c101105063.spfilter(c,e,tp,eg)
	return c:IsSetCard(0xe2) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not eg:IsExists(Card.IsCode,1,nil,c:GetCode())
end
function c101105063.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101105063.spconfilter,1,nil,e,tp,eg)
end
function c101105063.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,LOCATION_DECK)
end
function c101105063.spop(e,tp,eg,ep,ev,re,r,rp)
	if not (e:GetHandler():IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101105063.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,eg)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
