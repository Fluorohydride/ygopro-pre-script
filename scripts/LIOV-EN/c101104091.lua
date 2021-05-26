--War Rock Generations
--Script By JSY1728
function c101104091.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101104091+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101104091.condition)
	e1:SetTarget(c101104091.target)
	e1:SetOperation(c101104091.operation)
	c:RegisterEffect(e1)
end
function c101104091.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph>PHASE_MAIN1 and ph<PHASE_MAIN2) and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
end
function c101104091.filter(c,e,tp)
	return c:IsSetCard(0x15f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101104091.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101104091.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101104091.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101104091.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local sg=Duel.GetMatchingGroup(c101104091.disfilter,tp,LOCATION_MZONE,0,nil)
		if #sg>0 and Duel.GetTurnPlayer()==1-tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetRange(LOCATION_MZONE)
			e1:SetTargetRange(0,LOCATION_MZONE)
			e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(c101104091.atklimit)
			tc:RegisterEffect(e1)
			local fid=e:GetHandler():GetFieldID()
			tc:RegisterFlagEffect(101104091,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
			Duel.SpeclaiSummonComplete()
		end
	end
end
function c101104091.disfilter(c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c101104091.atklimit(e,c)
	return c~=e:GetHandler()
end