--阿吽の呼吸
--
--Script by JustFish
function c101102058.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101102058+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c101102058.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101102058,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,101102058)
	e2:SetCondition(c101102058.spcon)
	e2:SetTarget(c101102058.sptg)
	e2:SetOperation(c101102058.spop)
	c:RegisterEffect(e2)
end
function c101102058.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x24d) and c:IsAbleToHand()
end
function c101102058.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c101102058.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101102058,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c101102058.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsSetCard(0x24d)
end
function c101102058.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101102058.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101102058.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101102058.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,101102158,0x24d,0x4011,0,0,2,RACE_WARRIOR,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c101102058.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,101102158,0x24d,0x4011,0,0,2,RACE_WARRIOR,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,101102158)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101102058.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101102058.splimit(e,c)
	return not c:IsType(TYPE_FUSION) and c:IsLocation(LOCATION_EXTRA)
end
