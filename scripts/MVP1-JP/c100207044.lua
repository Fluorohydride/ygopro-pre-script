--方界曼荼羅
--Houkai Mandala
--Script by mercury233
function c100207044.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
	e1:SetCondition(c100207044.condition)
	e1:SetTarget(c100207044.target)
	e1:SetOperation(c100207044.activate)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAIN_ACTIVATING)
	e2:SetOperation(c100207044.disop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c100207044.descon)
	e3:SetOperation(c100207044.desop)
	c:RegisterEffect(e3)
end
function c100207044.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xe3) and c:IsFaceup()
end
function c100207044.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100207044.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100207044.spfilter(c,e,tp,tid)
	return c:IsReason(REASON_DESTROY) and c:IsType(TYPE_MONSTER) and c:GetTurnID()==tid
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100207044.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tid=Duel.GetTurnCount()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>0
		and Duel.IsExistingTarget(c100207044.spfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp,tid) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.SelectTarget(tp,c100207044.spfilter,tp,0,LOCATION_GRAVE,1,ft,nil,e,tp,tid)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c100207044.sfilter(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100207044.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(c100207044.sfilter,nil,e,tp)
	if sg:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if sg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=sg:Select(tp,ft,ft,nil)
	end
	local sc=sg:GetFirst()
	while sc and Duel.SpecialSummonStep(sc,0,tp,1-tp,false,false,POS_FACEUP) do
		c:SetCardTarget(sc)
		--
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e1)
		--
		sc:AddCounter(0x1038,1)
		--
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_ATTACK)
		e2:SetCondition(c100207032.condition)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e2)
		--
		local e3=e2:Clone()
		e3:SetCode(EFFECT_DISABLE)
		sc:RegisterEffect(e3)
		sc=sg:GetNext()
	end
	Duel.SpecialSummonComplete()
end
function c100207044.dfilter(c,g)
	return g:IsContains(c)
end
function c100207044.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetCardTarget()
	if re:IsActiveType(TYPE_MONSTER) and rp~=tp
		and Duel.IsExistingMatchingCard(c100207044.dfilter,tp,0,LOCATION_MZONE,1,nil,g) then
		Duel.NegateEffect(ev)
	end
end
function c100207044.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetCardTarget()
	return eg:FilterCount(c100207044.dfilter,nil,g)>0
		and not Duel.IsExistingMatchingCard(c100207044.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,g)
end
function c100207044.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
