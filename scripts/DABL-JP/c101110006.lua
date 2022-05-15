--BF－幻耀のスズリ
function c101110006.initial_effect(c)
	aux.AddCodeList(c,9012916)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101110006,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c101110006.thtg)
	e1:SetOperation(c101110006.thop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101110006,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101110006)
	e2:SetCost(c101110006.spcost)
	e2:SetTarget(c101110006.sptg)
	e2:SetOperation(c101110006.spop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(101110006,ACTIVITY_SPSUMMON,c101110006.counterfilter)
end
function c101110006.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_SYNCHRO)
end
function c101110006.thfilter(c)
	return aux.IsCodeListed(c,9012916) and not c:IsCode(101110006) and c:IsAbleToHand()
end
function c101110006.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101110006.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101110006.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101110006.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101110006.rfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0
end
function c101110006.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101110006.rfilter,1,nil,tp) and Duel.GetCustomActivityCount(5325155,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c101110006.rfilter,1,1,nil,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101110006.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.Release(g,REASON_COST)
end
function c101110006.splimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_SYNCHRO)
end
function c101110006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c101110006.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,101110007,0,TYPES_TOKEN_MONSTER,700,700,2,RACE_WINDBEAST,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp,101110007)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end