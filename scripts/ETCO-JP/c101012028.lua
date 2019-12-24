--王の影 ロプトル

--Scripted by mallu11
function c101012028.initial_effect(c)
	c:SetUniqueOnField(1,0,101012028)
	--atk/def up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c101012028.atktg)
	e1:SetValue(1000)
	e1:SetCondition(c101012028.atkcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101012028,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCountLimit(1,101012028)
	e3:SetCondition(c101012028.spcon)
	e3:SetCost(c101012028.spcost)
	e3:SetTarget(c101012028.sptg)
	e3:SetOperation(c101012028.spop)
	c:RegisterEffect(e3)
end
function c101012028.atktg(e,c)
	return c:IsFaceup() and c:IsSetCard(0x134)
end
function c101012028.atkcon(e)
	return Duel.GetTurnPlayer()==1-e:GetHandlerPlayer()
end
function c101012028.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c101012028.rfilter(c,e,tp)
	return c:IsSetCard(0x134) and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c101012028.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c101012028.spfilter(c,e,tp,code)
	return c:IsSetCard(0x134) and c:IsLevel(9) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101012028.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101012028.rfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c101012028.rfilter,1,1,nil,e,tp)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.Release(g,REASON_COST)
end
function c101012028.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101012028.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101012028.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,code)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
