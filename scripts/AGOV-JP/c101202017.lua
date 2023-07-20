--白銀の城の執事 アリアス
local s,id,o=GetID()
function s.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.stcon)
	e1:SetCost(s.stcost)
	e1:SetTarget(s.sttg)
	e1:SetOperation(s.stop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	
end

function s.stcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function s.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function s.stfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSSetable() 
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x17e) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local o1=Duel.IsExistingMatchingCard(s.stfilter,tp,LOCATION_HAND,0,1,nil) 
	local o2=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,e:GetHandler(),e,tp)
	if chk==0 then return o1 or o2  end
end
function s.stop(e,tp,eg,ep,ev,re,r,rp)
	if tc:IsRelateToEffect(e) then
		local off=1
		local ops={}
		local opval={}
		local spg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
		local stg=Duel.GetMatchingGroup(s.stfilter,tp,LOCATION_HAND,0,nil)
		if #spg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			ops[off]=aux.Stringid(id,0)
			opval[off-1]=1
			off=off+1
		end
		if #stg>0 then
			ops[off]=aux.Stringid(id,1)
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
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCurrentChain()
	if ct<2 then return end
	local te,p=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return te and (te:GetHandler():IsSetCard(0x17e) or te:GetHandler():IsType(TYPE_TRAP)) and p==tp and rp==1-tp
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end

