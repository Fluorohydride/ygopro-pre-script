--獣湧き肉躍り
--
--Scripted by 龙骑
function c100250011.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,100250011+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100250011.condition)
	e1:SetTarget(c100250011.target)
	e1:SetOperation(c100250011.activate)
	c:RegisterEffect(e1)
end
function c100250011.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local atk=g:GetSum(Card.GetAttack)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil and atk>=8000
end
function c100250011.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end
function c100250011.spfilter1(c,e,tp,chk)
	return c100250011.spfilter(c,e,tp)
		and Duel.IsExistingMatchingCard(c100250011.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetOriginalCode(),chk)
end
function c100250011.spfilter2(c,e,tp,code1,chk)
	return c100250011.spfilter(c,e,tp)
		and c:GetOriginalCode()~=code1
		and Duel.IsExistingMatchingCard(c100250011.spfilter3,tp,LOCATION_GRAVE,0,1,nil,e,tp,code1,c:GetOriginalCode(),chk)
end
function c100250011.spfilter3(c,e,tp,code1,code2,chk)
	return c100250011.spfilter(c,e,tp)
		and c:GetOriginalCode()~=code1 and c:GetOriginalCode()~=code2
		and (not chk or not (c:IsHasEffect(EFFECT_NECRO_VALLEY) and Duel.IsChainDisablable(0)))
end
function c100250011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=3 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsExistingMatchingCard(c100250011.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c100250011.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>=3 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsExistingMatchingCard(c100250011.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp,true) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg1=Duel.SelectMatchingCard(tp,c100250011.spfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp,true)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=Duel.SelectMatchingCard(tp,c100250011.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,sg1:GetFirst():GetOriginalCode(),true)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg3=Duel.SelectMatchingCard(tp,c100250011.spfilter3,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,sg1:GetFirst():GetOriginalCode(),sg2:GetFirst():GetOriginalCode(),true)
		sg1:Merge(sg2)
		sg1:Merge(sg3)
		Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
