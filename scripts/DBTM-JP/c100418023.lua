--ウェルカム・ラビュリンス

--Scripted by mallu11
function c100418023.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100418023,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100418023)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c100418023.target)
	e1:SetOperation(c100418023.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100418023,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100418023+100)
	e2:SetCondition(c100418023.setcon)
	e2:SetTarget(c100418023.settg)
	e2:SetOperation(c100418023.setop)
	c:RegisterEffect(e2)
end
function c100418023.spfilter(c,e,tp)
	return c:IsSetCard(0x280) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100418023.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c100418023.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c100418023.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local res=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100418023.spfilter),tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			res=Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local chk=not c:IsStatus(STATUS_ACT_FROM_HAND) and c:IsSetCard(0x280) and c:GetType()==TYPE_TRAP and e:IsHasType(EFFECT_TYPE_ACTIVATE)
	if chk and Duel.IsPlayerAffectedByEffect(tp,100418021) and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) and Duel.SelectYesNo(tp,aux.Stringid(100418021,0)) then
		if res>0 then Duel.BreakEffect() end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
		Duel.Hint(HINT_CARD,0,100418021)
		local te=Duel.IsPlayerAffectedByEffect(tp,100418021)
		te:UseCountLimit(tp)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c100418023.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function c100418023.splimit(e,c)
	return not c:IsRace(RACE_FIEND) and c:IsLocation(LOCATION_DECK+LOCATION_EXTRA)
end
function c100418023.cfilter(c)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsReason(REASON_EFFECT)
end
function c100418023.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100418023.cfilter,1,nil) and not eg:IsContains(e:GetHandler()) and rp==tp and re:IsActiveType(TYPE_TRAP) and re:GetHandler():GetType()==TYPE_TRAP and aux.exccon(e)
end
function c100418023.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c100418023.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
end
