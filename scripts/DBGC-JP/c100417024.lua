--エクソシスター・バディス
--
--Scripted by KillerDJ
function c100417024.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,100417024+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c100417024.cost)
	e1:SetTarget(c100417024.target)
	e1:SetOperation(c100417024.activate)
	c:RegisterEffect(e1)
end
function c100417024.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c100417024.spfilter1(c,e,tp)
	return c:IsSetCard(0x271) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c100417024.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c100417024.spfilter2(c,e,tp,code)
	return c:IsSetCard(0x271) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and aux.IsCodeListed(c,code)
end
function c100417024.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c100417024.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,LOCATION_DECK)
end
function c100417024.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c100417024.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g1==0 then return end
	local g2=Duel.SelectMatchingCard(tp,c100417024.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,g1:GetFirst():GetCode())
	g1:Merge(g2)
	local tc=g1:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(100417024,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(100417024,1))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c100417024.tdcon)
		e1:SetOperation(c100417024.tdop)
		Duel.RegisterEffect(e1,tp)
		tc=g1:GetNext()
	end
	Duel.SpecialSummonComplete()
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c100417024.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c100417024.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(100417024)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c100417024.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end
function c100417024.splimit(e,c)
	return not c:IsSetCard(0x271) and c:IsLocation(LOCATION_EXTRA)
end
