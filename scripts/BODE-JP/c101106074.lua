--ふわんだりぃずと夢の町
--Script By JSY1728
function c101106074.initial_effect(c)
	--Normal Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101106074,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCondition(c101106074.sumcon)
	e1:SetTarget(c101106074.sumtg)
	e1:SetOperation(c101106074.sumop)
	c:RegisterEffect(e1)
	--Defense Position
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101106074,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101106074)
	e2:SetCondition(c101106074.poscon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101106074.postg)
	e2:SetOperation(c101106074.posop)
	c:RegisterEffect(e2)
end
function c101106074.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c101106074.sumfilter(c)
	return c:IsLevelBelow(4) and c:IsRace(RACE_WINDBEAST) and c:IsSummonable(true,nil)
end
function c101106074.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101106074.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c101106074.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c101106074.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function c101106074.cfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsLevelAbove(7) and c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c101106074.poscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101106074.cfilter,1,nil,tp)
end
function c101106074.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c101106074.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101106074.posfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c101106074.posfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c101106074.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101106074.posfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
