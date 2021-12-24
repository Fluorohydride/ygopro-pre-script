--捕食植物ビブリスプ
--
--Script by JSY1728
function c101108017.initial_effect(c)
	--Effect 1 : Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101108017,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,101108017)
	e1:SetTarget(c101108017.thtg)
	e1:SetOperation(c101108017.thop)
	c:RegisterEffect(e1)
	--Effect 2 : Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101108017,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101108017+100)
	e2:SetCondition(c101108017.spcon)
	e2:SetTarget(c101108017.sptg)
	e2:SetOperation(c101108017.spop)
	c:RegisterEffect(e2)
end
function c101108017.thfilter(c)
	return c:IsSetCard(0x10f3) and c:IsType(TYPE_MONSTER) and not c:IsCode(101108017) and c:IsAbleToHand()
end
function c101108017.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101108017.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101108017.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101108017.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101108017.cfilter(c)
	return c:IsFaceup() and c:GetCounter(0x1041)>0
end
function c101108017.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101108017.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c101108017.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101108017.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
