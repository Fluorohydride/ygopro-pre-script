--ジェネレーション・ネクスト

--Scripted by mallu11
function c100423014.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,100423014+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100423014.condition)
	e1:SetTarget(c100423014.target)
	e1:SetOperation(c100423014.activate)
	c:RegisterEffect(e1)
end
function c100423014.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c100423014.thfilter(c)
	return (c:IsSetCard(0x3008) or c:IsSetCard(0xa4) or c:IsSetCard(0x1f)) and c:IsAttackBelow(math.abs(Duel.GetLP(0)-Duel.GetLP(1))) and c:IsAbleToHand()
end
function c100423014.spfilter(c,e,tp)
	return (c:IsSetCard(0x3008) or c:IsSetCard(0xa4) or c:IsSetCard(0x1f)) and c:IsAttackBelow(math.abs(Duel.GetLP(0)-Duel.GetLP(1))) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100423014.cfilter(c,e,tp)
	return (c:IsSetCard(0x3008) or c:IsSetCard(0xa4) or c:IsSetCard(0x1f)) and c:IsAttackBelow(math.abs(Duel.GetLP(0)-Duel.GetLP(1))) and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c100423014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_DECK+LOCATION_GRAVE
	if chk==0 then return Duel.IsExistingMatchingCard(c100423014.thfilter,tp,loc,0,1,nil) or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c100423014.spfilter,tp,loc,0,1,nil,e,tp)) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,loc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,loc)
end
function c100423014.activate(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_DECK+LOCATION_GRAVE
	local g=nil
	local s=0
	local flag=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100423014.thfilter),tp,loc,0,1,1,nil)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			e:SetLabelObject(tc)
			s=Duel.SelectOption(tp,1190)
		end
	else
		g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100423014.cfilter),tp,loc,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			e:SetLabelObject(tc)
			local b1=tc:IsAbleToHand()
			local b2=tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			if b1 and not b2 then
				s=Duel.SelectOption(tp,1190)
			end
			if not b1 and b2 then
				s=Duel.SelectOption(tp,1152)+1
			end
			if b1 and b2 then
				s=Duel.SelectOption(tp,1190,1152)
			end
		end
	end
	local tc=e:GetLabelObject()
	if s==0 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		if tc:IsLocation(LOCATION_HAND) then
			flag=1
		end
	end
	if s==1 then
		flag=Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	if flag~=0 then
		local gc=e:GetLabelObject()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(c100423014.aclimit)
		e1:SetLabel(gc:GetCode())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c100423014.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
