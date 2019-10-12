--幻魔の肖像

--Scripted by mallu11
function c101011079.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,101011079+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101011079.target)
	e1:SetOperation(c101011079.activate)
	c:RegisterEffect(e1)
end
function c101011079.cfilter(c,e,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c101011079.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,c:GetCode())
end
function c101011079.spfilter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101011079.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c:IsControler(1-tp) and c101011079.cfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c101011079.cfilter,tp,0,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,c101011079.cfilter,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c101011079.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local code=tc:GetCode()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c101011079.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp,code)
		local sc=g:GetFirst()
		if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 then
			sc:RegisterFlagEffect(101011079,RESET_EVENT+RESETS_STANDARD,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetLabel(Duel.GetTurnCount()+1)
			e1:SetLabelObject(sc)
			e1:SetCondition(c101011079.tdcon)
			e1:SetOperation(c101011079.tdop)
			Duel.RegisterEffect(e1,tp)
		end
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetTarget(c101011079.splimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c101011079.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(101011079)~=0 then
		return Duel.GetTurnCount()==e:GetLabel()
	else
		e:Reset()
		return false
	end
end
function c101011079.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end
function c101011079.splimit(e,c)
	return c:IsLocation(LOCATION_DECK) or c:IsLocation(LOCATION_EXTRA)
end
