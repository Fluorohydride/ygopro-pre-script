--神聖魔皇后セレーネ

--Scripted by mallu11
function c100257036.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,3,c100257036.lcheck)
	c:EnableCounterPermit(0x1)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100257036,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c100257036.ctcon)
	e1:SetOperation(c100257036.ctop)
	c:RegisterEffect(e1)
	--can not be attack target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetCondition(c100257036.atcon)
	e2:SetValue(aux.imval1)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100257036,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c100257036.spcon)
	e3:SetCost(c100257036.spcost)
	e3:SetTarget(c100257036.sptg)
	e3:SetOperation(c100257036.spop)
	c:RegisterEffect(e3)
end
function c100257036.lcheck(g,lc)
	return g:IsExists(Card.IsLinkRace,1,nil,RACE_SPELLCASTER)
end
function c100257036.atfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x12a)
end
function c100257036.atcon(e)
	return Duel.IsExistingMatchingCard(c100257036.atfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c100257036.ctfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function c100257036.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c100257036.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=LOCATION_ONFIELD+LOCATION_GRAVE
	local g=Duel.GetMatchingGroup(c100257036.ctfilter,tp,loc,loc,nil)
	if c:IsRelateToEffect(e) and c:IsFaceup() and g:GetCount()>0 then
		c:AddCounter(0x1,g:GetCount())
	end
end
function c100257036.spfilter(c,e,tp,zone)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp,zone)
end
function c100257036.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c100257036.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,0x1,3,REASON_COST) end
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,0,0x1,3,REASON_COST)
end
function c100257036.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100257036.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c100257036.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
	if zone==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100257036.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE,zone)
	end
end
