--アクセルシンクロ・スターダスト・ドラゴン

--Scripted by mallu11
function c100287022.initial_effect(c)
	aux.AddCodeList(c,44508094)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100287022,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,100287022)
	e1:SetCondition(c100287022.spcon)
	e1:SetTarget(c100287022.sptg)
	e1:SetOperation(c100287022.spop)
	c:RegisterEffect(e1)
	--synchro effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100287022,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c100287022.sccon)
	e2:SetCost(c100287022.sccost)
	e2:SetTarget(c100287022.sctg)
	e2:SetOperation(c100287022.scop)
	c:RegisterEffect(e2)
end
function c100287022.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c100287022.spfilter(c,e,tp)
	return c:IsLevelBelow(2) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100287022.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c100287022.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c100287022.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100287022.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
function c100287022.sccon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c100287022.excostfilter(c,tp)
	return c:IsAbleToRemoveAsCost() and c:IsHasEffect(84012625,tp)
end
function c100287022.chkfilter(c,tp,mc,mg,opchk)
	return Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
		and (opchk or Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,c,nil,mg))
end
function c100287022.scfilter(c,e,tp,mc,b1,b2,tgchk,opchk)
	if not (c:IsCode(44508094) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)) then return false end
	local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if mg:IsExists(Card.GetHandSynchro,1,nil) then
		local mg2=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
		if mg2:GetCount()>0 then mg:Merge(mg2) end
	end
	mg:AddCard(c)
	if tgchk then
		return c100287022.chkfilter(c,tp,nil,mg,opchk)
	else
		return (b1 and c100287022.chkfilter(c,tp,mc,mg-mc)) or (b2 and c100287022.chkfilter(c,tp,nil,mg))
	end
end
function c100287022.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	local c=e:GetHandler()
	local ect1=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	local ect2=aux.ExtraDeckSummonCountLimit and Duel.IsPlayerAffectedByEffect(tp,92345028)
		and aux.ExtraDeckSummonCountLimit[tp]
	local g=Duel.GetMatchingGroup(c100287022.excostfilter,tp,LOCATION_GRAVE,0,nil,tp)
	local b1=c:IsReleasable()
	local b2=g:GetCount()>0
	local b3=b1 and Duel.IsExistingMatchingCard(c100287022.scfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,b1,nil)
	local b4=b2 and Duel.IsExistingMatchingCard(c100287022.scfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,nil,b2)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and (not ect1 or ect1>1) and (not ect2 or ect2>1) and (b1 or b2)
		and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
		and (b3 or b4) end
	local mg=Group.CreateGroup()
	local tc=nil
	if b3 then mg:AddCard(c) end
	if b4 then mg:Merge(g) end
	if mg:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(84012625,0))
		tc=mg:Select(tp,1,1,nil):GetFirst()
	else
		tc=mg:GetFirst()
	end
	local te=tc:IsHasEffect(84012625,tp)
	if te then
		Duel.Remove(tc,POS_FACEUP,REASON_COST+REASON_REPLACE)
	else
		Duel.Release(tc,REASON_COST)
	end
end
function c100287022.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ect1=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	local ect2=aux.ExtraDeckSummonCountLimit and Duel.IsPlayerAffectedByEffect(tp,92345028)
		and aux.ExtraDeckSummonCountLimit[tp]
	if chk==0 then
		if e:GetLabel()==100 then
			e:SetLabel(0)
			return true
		end
		return Duel.IsPlayerCanSpecialSummonCount(tp,2)
			and (not ect1 or ect1>1) and (not ect2 or ect2>1)
			and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
			and Duel.IsExistingMatchingCard(c100287022.scfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,nil,nil,true)
	end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100287022.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100287022.scfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c,nil,nil,true,true)
	local tc=g:GetFirst()
	local res=nil
	if tc and Duel.SpecialSummonStep(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(c100287022.immval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetOwnerPlayer(tp)
		tc:RegisterEffect(e1,true)
		res=true
	end
	Duel.SpecialSummonComplete()
	tc:CompleteProcedure()
	Duel.RaiseEvent(c,EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
	local mg=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil)
	if res and mg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=mg:Select(tp,1,1,nil)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(c100287022.immval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
		e1:SetOwnerPlayer(tp)
		sg:GetFirst():RegisterEffect(e1,true)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil)
	end
end
function c100287022.immval(e,te)
	return te:GetHandlerPlayer()~=e:GetOwnerPlayer() and te:IsActivated()
end
