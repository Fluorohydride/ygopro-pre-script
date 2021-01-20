--War Lock Skyler
--Scripted by Kohana Sonogami
function c101103096.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c101103096.val)
	c:RegisterEffect(e1)
	--special summon & atkchange
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101103096,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCountLimit(1,101103096)
	e2:SetCondition(c101103096.spcon)
	e2:SetTarget(c101103096.sptg)
	e2:SetOperation(c101103096.spop)
	c:RegisterEffect(e2)
end
function c101103096.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c101103096.val(e,c)
	return Duel.GetMatchingGroupCount(c101103096.atkfilter,c:GetControler(),0,LOCATION_MZONE,nil)*100
end
function c101103096.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
		and tc and tc:IsFaceup() and tc:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_WARRIOR)
end
function c101103096.spfilter(c,e,tp)
	return c:IsLevelAbove(5) and c:IsSetCard(0x263) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101103096.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c101103096.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101103096.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101103096.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101103096.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x263)
end
function c101103096.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc1=Duel.GetFirstTarget()
	if tc1:IsRelateToEffect(e) and Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP)~=0
		and Duel.IsExistingMatchingCard(c101103096.atkfilter,tp,LOCATION_MZONE,0,1,nil) then
		Duel.BreakEffect()
		local sg=Duel.GetMatchingGroup(c101103096.atkfilter,tp,LOCATION_MZONE,0,nil)
		local tc2=sg:GetFirst() 
		for tc2 in aux.Next(sg) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(200)
			tc2:RegisterEffect(e1)
		end
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsLevelBelow,5))
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
