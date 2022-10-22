--ヌメロン・クリエイション
--
--Script by Trishula9
function c101111052.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101111052.condition)
	e1:SetTarget(c101111052.target)
	e1:SetOperation(c101111052.activate)
	c:RegisterEffect(e1)
end
function c101111052.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_DRAGON) and c:GetBaseAttack()>=3000 and c:IsFaceup()
end
function c101111052.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c101111052.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)>=3
end
function c101111052.spfilter(c,e,tp)
	return c:IsSetCard(0x48) and c:IsRace(RACE_DRAGON) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c101111052.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,101111052)==0
		and Duel.IsExistingMatchingCard(c101111052.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101111052.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,101111052)~=0 then return end
	Duel.RegisterFlagEffect(tp,101111052,RESET_PHASE+PHASE_END,0,1)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c101111052.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 and tc:IsLocation(LOCATION_MZONE)
		and c:IsLocation(LOCATION_ONFIELD) and c:IsRelateToEffect(e) and c:IsCanOverlay() then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.Overlay(tc,Group.FromCards(c))
	end
end