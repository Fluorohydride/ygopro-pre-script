--白銀の城の執事 アリアス
--Script by Dio0
function c101202017.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101202017,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,101202017)
	e1:SetCondition(c101202017.stcon)
	e1:SetCost(c101202017.stcost)
	e1:SetTarget(c101202017.sttg)
	e1:SetOperation(c101202017.stop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,12020011)
	e2:SetCondition(c101202017.spcon)
	e2:SetTarget(c101202017.sptg)
	e2:SetOperation(c101202017.spop)
	c:RegisterEffect(e2)
	
end

function c101202017.stcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c101202017.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function c101202017.stfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSetCard(0x17e) and c:IsSSetable() and c:IsSSetable()
end
function c101202017.spfilter(c,e,tp)
	return c:IsSetCard(0x17e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101202017.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101202017.stfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
end
function c101202017.stop(e,tp,eg,ep,ev,re,r,rp)
	local off=1
	local ops={}
	local opval={}
	local spg=Duel.GetMatchingGroup(c101202017.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	local stg=Duel.GetMatchingGroup(c101202017.stfilter,tp,LOCATION_HAND,0,nil)
	if #spg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		ops[off]=aux.Stringid(101202017,0)
		opval[off-1]=1
		off=off+1
	end
	if #stg>0 then
		ops[off]=aux.Stringid(101202017,1)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=spg:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
	if opval[op]==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=stg:Select(tp,1,1,nil)
		if Duel.SSet(tp,sg,tp,false)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			sg:GetFirst():RegisterEffect(e1)
		end
	end
end

function c101202017.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCurrentChain()
	if ct<2 then return end
	local te,p=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return te and (te:GetHandler():IsSetCard(0x17e) or te:GetHandler():IsType(TYPE_TRAP)) and p==tp and rp==1-tp
end
function c101202017.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101202017.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end

