--リミット・コード
--Limit Code
--scripted by Larry126
function c101004067.initial_effect(c)
	c:EnableCounterPermit(0x47)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101004067+EFFECT_COUNT_CODE_DUEL)
	e1:SetTarget(c101004067.target)
	e1:SetOperation(c101004067.operation)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetOperation(c101004067.desop)
	c:RegisterEffect(e2)
	--remove counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c101004067.rccon)
	e3:SetOperation(c101004067.rcop)
	c:RegisterEffect(e3)
end
function c101004067.rccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c101004067.rcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RemoveCounter(tp,0x47,1,REASON_EFFECT)
	if c:GetCounter(0x47)<1 then
		local tc=c:GetFirstCardTarget()
		if tc and tc:IsLocation(LOCATION_MZONE) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
function c101004067.spfilter(c,e,tp)
	return c:IsSetCard(0x101) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c101004067.cfilter(c)
	return c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_LINK)
end
function c101004067.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c101004067.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c101004067.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c101004067.cfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,e:GetHandler(),1,tp,LOCATION_SZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c101004067.eqlimit(e,c)
	return e:GetLabelObject()==c
end
function c101004067.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c101004067.cfilter,tp,LOCATION_GRAVE,0,nil)
	if c:IsRelateToEffect(e) and g:GetCount()>0 and c:IsCanAddCounter(0x47,g:GetCount()) and c:AddCounter(0x47,g:GetCount()) then
		if Duel.GetLocationCountFromEx(tp)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c101004067.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if not tc then return end
		Duel.BreakEffect()
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.Equip(tp,c,tc)
			c:CancelToGrave()
			--Add Equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c101004067.eqlimit)
			e1:SetLabelObject(tc)
			c:RegisterEffect(e1)
		end
	end
end
function c101004067.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end