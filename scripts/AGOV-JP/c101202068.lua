--覇王龍の奇跡
--
--Script by Trishula9 & mercury233
function c101202068.initial_effect(c)
	aux.AddCodeList(c,13331639)
	--select effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101202068,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c101202068.condition)
	e1:SetTarget(c101202068.target)
	c:RegisterEffect(e1)
end
function c101202068.cfilter(c)
	return c:IsCode(13331639) and c:IsFaceup()
end
function c101202068.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101202068.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c101202068.desfilter(c)
	return c:IsCode(13331639) and c:IsFaceup()
end
function c101202068.spfilter(c,e,tp)
	return ((c:IsSetCard(0x99) and c:IsType(TYPE_PENDULUM)) or (c:IsCode(13331639) and c:IsAttribute(ATTRIBUTE_LIGHT)))
		and ((c:IsLocation(LOCATION_DECK) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
		or (c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0))
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c101202068.psfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup() and not c:IsForbidden()
end
function c101202068.ssfilter(c)
	return c:IsType(TYPE_QUICKPLAY) and c:IsSSetable()
end
function c101202068.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(c101202068.desfilter,tp,LOCATION_ONFIELD,0,nil)
	local g2=Duel.GetMatchingGroup(c101202068.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp)
	local b1=Duel.GetFlagEffect(tp,101202068+1)==0
		and g1:GetCount()>0 and g2:GetCount()>0
	local b2=Duel.GetFlagEffect(tp,101202068+2)==0
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c101202068.psfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b3=Duel.GetFlagEffect(tp,101202068+3)==0
		and Duel.IsExistingMatchingCard(c101202068.ssfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 or b3 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(101202068,1)},
		{b2,aux.Stringid(101202068,2)},
		{b3,aux.Stringid(101202068,3)})
	Duel.RegisterFlagEffect(tp,101202068+op,RESET_PHASE+PHASE_END,0,1)
	if op==1 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
		e:SetOperation(c101202068.spop)
	elseif op==2 then
		e:SetCategory(0)
		e:SetOperation(c101202068.psop)
	else
		e:SetCategory(0)
		e:SetOperation(c101202068.ssop)
	end
end
function c101202068.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,c101202068.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	local g2=Duel.GetMatchingGroup(c101202068.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp)
	if Duel.Destroy(g1,REASON_EFFECT)>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=g2:Select(tp,1,1,nil)
		Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c101202068.psop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c101202068.psfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	if Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,false) then
		tc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
end
function c101202068.ssop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c101202068.ssfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end
