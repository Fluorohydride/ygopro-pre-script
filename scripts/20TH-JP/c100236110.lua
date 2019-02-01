--スターダスト・ミラージュ
--
--Script by JoyJ
function c100236110.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c100236110.spcon)
	e1:SetTarget(c100236110.sptg)
	e1:SetOperation(c100236110.spop)
	c:RegisterEffect(e1)
	if not c100236110.GlobalRegister then
		c100236110.GlobalRegister=Effect.CreateEffect(c)
		c100236110.GlobalRegister:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		c100236110.GlobalRegister:SetCode(EVENT_DESTROYED)
		c100236110.GlobalRegister:SetOperation(c100236110.globalop)
		Duel.RegisterEffect(e1,0)
	end
end
function c100236110.spfilter(c,e,tp)
	return c:GetFlagEffect(100236110)~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100236110.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100236110.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c100236110.spop(e,tp,eg,ep,ev,re,r,rp)
	local SpCount=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetMatchingGroup(c100236110.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if SpCount < 1 or tg:GetCount() < 1 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then SpCount=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=tg:Select(tp,ft,ft,nil)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
function c100236110.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100236110.spfieldfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100236110.globalfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-c:GetControler())
end
function c100236110.globalforeach(c)
	c:RegisterFlagEffect(100236110,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end
function c100236110.globalop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c100236110.globalfilter,nil)
	g:ForEach(c100236110.globalforeach)
end
function c100236110.spfieldfilter(c)
	return c:IsLevelAbove(8) and c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_DRAGON)
end
