--BF-無頼のヴァータ
function c101110001.initial_effect(c)
	--- had Black-Winged Dragon written on
	aux.AddCodeList(c, 9012916)

	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101110001+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101110001.spSelfCon)
	c:RegisterEffect(e1)

	--extra special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101110001,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101110101)
	e2:SetCondition(c101110001.spDragonCon)
	e2:SetOperation(c101110001.spDragonOp)
	c:RegisterEffect(e2)
end

function c101110001.spSelfFilter(c)
	return c:IsFaceup() and c:IsSetCard(0x33) and not c:IsCode(101110001)
end

function c101110001.spSelfCon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101110001.spSelfFilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end

function c101110001.spDragonMetFilter(c)
	return c:IsSetCard(0x33) and (c:IsType(TYPE_MONSTER) and c:GetLevel() < 8 and (not c:IsType(TYPE_TUNER)))
				and c:IsAbleToGraveAsCost()
end

function c101110001.spDragonDragonFilter(c, e, tp)
	-- TODO:MAYBE have todo other check
	return c:IsCode(9012916) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c101110001.spDragonCon(e,tp,eg,ep,ev,re,r,rp)
	local hasDragon = Duel.IsExistingMatchingCard(c101110001.spDragonDragonFilter, tp, LOCATION_EXTRA,0, 1, nil, e, tp)
	local selfLevelRight = e:GetHandler():GetLevel() < 8 and e:GetHandler():IsAbleToGraveAsCost()

	local g=Duel.GetMatchingGroup(c101110001.spDragonMetFilter,tp,LOCATION_DECK,0,nil)
	local restLevelRight = g:CheckWithSumEqual(Card.GetLevel,8 - e:GetHandler():GetLevel(),1,80)

	return hasDragon and selfLevelRight and restLevelRight
end

function c101110001.spDragonOp(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101110001.spDragonMetFilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local mg=g:SelectWithSumEqual(tp,Card.GetLevel,8 - e:GetHandler():GetLevel(),1,80)
	if mg and mg:GetCount()>0 then
		mg:AddCard(e:GetHandler())
		if Duel.SendtoGrave(mg,nil,REASON_EFFECT) > 0 then
			local sg=Duel.SelectMatchingCard(tp,c101110001.spDragonDragonFilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)   
		end  
	end

	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101110001.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function c101110001.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_DARK) and c:IsLocation(LOCATION_EXTRA)
end

