--D－HERO デストロイフェニックスガイ
--
--Script by mercury233
function c101106039.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c101106039.matfilter,aux.FilterBoolFunction(Card.IsFusionSetCard,0xc008),true)
	--atkdown
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c101106039.atkval)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101106039,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101106039)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(c101106039.destg)
	e2:SetOperation(c101106039.desop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101106039,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,101106039+100)
	e3:SetCondition(c101106039.regcon)
	e3:SetOperation(c101106039.regop)
	c:RegisterEffect(e3)
end
c101106039.material_setcode=0xc008
function c101106039.matfilter(c)
	return c:IsFusionSetCard(0x8) and c:IsLevelAbove(6)
end
function c101106039.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,0x8)*-200
end
function c101106039.desfilter1(c)
	return Duel.IsExistingMatchingCard(nil,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function c101106039.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c101106039.desfilter1,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c101106039.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,c101106039.desfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	if not g1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,g1)
	g1:Merge(g2)
	Duel.HintSelection(g1)
	Duel.Destroy(g1,REASON_EFFECT)
end
function c101106039.regcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c101106039.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(c101106039.spcon)
	e1:SetOperation(c101106039.spop)
	if Duel.GetCurrentPhase()<=PHASE_STANDBY then
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	Duel.RegisterEffect(e1,tp)
end
function c101106039.spfilter(c,e,tp)
	return c:IsSetCard(0xc008) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101106039.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101106039.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
end
function c101106039.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,101106039)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101106039.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
