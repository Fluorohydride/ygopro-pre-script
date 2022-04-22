--現世離レ

--Scripted by mallu11
function c101109078.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,101109078+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101109078.target)
	e1:SetOperation(c101109078.activate)
	c:RegisterEffect(e1)
end
function c101109078.cfilter(c,e,tp)
	return c:IsAbleToGrave() and Duel.IsExistingTarget(c101109078.setfilter,tp,0,LOCATION_GRAVE,1,nil,c,e,tp)
end
function c101109078.setfilter(c,cc,e,tp)
	local b1=c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,1-tp)
	local b2=c:IsSSetable(true)
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
	if cc:IsLocation(LOCATION_MZONE) and ft<=0 then
		return b1
	end
	local st=Duel.GetLocationCount(1-tp,LOCATION_SZONE,tp)
	if cc:IsLocation(LOCATION_SZONE) and cc:GetSequence()<5 and st<=0 then
		return b2
	end
	return b1 or b2
end
function c101109078.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c101109078.cfilter,tp,0,LOCATION_ONFIELD,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c101109078.cfilter,tp,0,LOCATION_ONFIELD,1,1,nil,e,tp)
	e:SetLabelObject(g:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g2=Duel.SelectTarget(tp,c101109078.setfilter,tp,0,LOCATION_GRAVE,1,1,nil,g:GetFirst(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	if g2:GetFirst():IsType(TYPE_MONSTER) then
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	else
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	end
end
function c101109078.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc2=tg:GetFirst()
	if tc2==tc then tc2=tg:GetNext() end
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) and tc2:IsRelateToEffect(e) then
		if tc2:IsType(TYPE_MONSTER) then
			Duel.SpecialSummon(tc2,0,tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
		else
			Duel.SSet(tp,tc2,1-tp)
		end
	end
end
