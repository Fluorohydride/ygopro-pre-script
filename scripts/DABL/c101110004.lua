--BF-幻耀のスズリ
function c101110004.initial_effect(c)
	--- has dragon in content
	aux.AddCodeList(c, 9012916)

	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101110004,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c101110004.searchTarget)
	e1:SetOperation(c101110004.searchOperation)
	c:RegisterEffect(e1)

	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101110004,1))
	e2:SetCategory(CATEGORY_RELEASE + CATEGORY_SPECIAL_SUMMON + CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1, 101110004)
	e2:SetCost(c101110004.tkCost)
	e2:SetTarget(c101110004.tkTarget)
	e2:SetOperation(c101110004.tkOperation)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(101110004,ACTIVITY_SPSUMMON,c101110004.counterfilter)
end

function c101110004.searchFilter(c)
	local hasDragronWriteOn = aux.IsCodeListed(c,9012916) or c:IsCode(17465972) or c:IsCode(80254726)
	return hasDragronWriteOn and c:IsAbleToHand() and not c:IsCode(101110004)
end

function c101110004.searchTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101110004.searchFilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c101110004.searchOperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101110004.searchFilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c101110004.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA)
end

function c101110004.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_SYNCHRO)
end

function c101110004.tkCost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.GetCustomActivityCount(101110004,tp,ACTIVITY_SPSUMMON)==0
				and Duel.CheckReleaseGroup(tp,Card.IsLocation,1,nil,LOCATION_MZONE) 
	end
	local g=Duel.SelectReleaseGroup(tp,Card.IsLocation,1,1,nil,LOCATION_MZONE)
	Duel.Release(g,REASON_COST)

	-- can only sp syn monster from extra
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101110004.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function c101110004.tkTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end

function c101110004.tkOperation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,11100006,0,
			TYPES_TOKEN_MONSTER + TYPE_TUNER,700,700,2,RACE_WINDBEAST,ATTRIBUTE_DARK) then 
		return 
	end
	local token=Duel.CreateToken(tp,11100006)
	local spsCount = Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	if spsCount > 0 then
		Duel.BreakEffect()
		Duel.Damage(tp,700,REASON_EFFECT)
	end
end
