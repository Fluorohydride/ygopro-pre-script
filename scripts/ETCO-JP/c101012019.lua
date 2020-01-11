--カッター・シャーク
--
--Scripted by mallu11
function c101012019.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101012019,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101012019)
	e1:SetTarget(c101012019.sptg)
	e1:SetOperation(c101012019.spop)
	c:RegisterEffect(e1)
	--xyzlv
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_XYZ_LEVEL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c101012019.xyzlv)
	c:RegisterEffect(e2)
end
function c101012019.tgfilter(c,e,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsLevelAbove(1) and Duel.IsExistingMatchingCard(c101012019.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetLevel(),c:GetCode())
end
function c101012019.spfilter(c,e,tp,lv,code)
	return c:IsRace(RACE_FISH) and c:IsLevel(lv) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c101012019.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101012019.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101012019.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c101012019.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101012019.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local lv=tc:GetLevel()
		local code=tc:GetCode()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c101012019.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv,code)
		local tc=g:GetFirst()
		if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			Duel.SpecialSummonComplete()
		end
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTarget(c101012019.splimit)
	Duel.RegisterEffect(e2,tp)
end
function c101012019.splimit(e,c)
	return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)
end
function c101012019.xyzlv(e,c,rc)
	if rc:IsAttribute(ATTRIBUTE_WATER) and rc:IsRank(3) then
		return c:GetLevel()+0x10000*3
	elseif rc:IsAttribute(ATTRIBUTE_WATER) and rc:IsRank(5) then
		return c:GetLevel()+0x10000*5
	else
		return c:GetLevel()
	end
end
