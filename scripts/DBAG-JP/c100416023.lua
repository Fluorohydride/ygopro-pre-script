--ドレミコード・スケール

--scripted by Xylen5967 & mercury233
function c100416023.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100416023+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100416023.target)
	c:RegisterEffect(e1)
end
function c100416023.cfilter(c)
	return c:IsSetCard(0x265) and c:GetOriginalType()&TYPE_PENDULUM>0 and c:IsFaceup()
end
function c100416023.tpfilter(c)
	return c:IsSetCard(0x265) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and not c:IsForbidden()
end
function c100416023.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x265) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100416023.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c100416023.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	local b1=ct>=3 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_PZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c100416023.tpfilter,tp,LOCATION_EXTRA,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)>0
	local b2=ct>=5 and Duel.IsExistingMatchingCard(c100416023.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b3=ct>=7 and Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)>0
	if chk==0 then return b1 or b2 or b3 end
end
function c100416023.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100416023.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	local b1=ct>=3 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_PZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c100416023.tpfilter,tp,LOCATION_EXTRA,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)>0
	local b2=ct>=5 and Duel.IsExistingMatchingCard(c100416023.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b3=ct>=7 and Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)>0
	if b1 and Duel.SelectYesNo(tp,aux.Stringid(100416023,0)) then
		c100416023.place(e,tp,eg,ep,ev,re,r,rp)
	end
	b2=ct>=5 and Duel.IsExistingMatchingCard(c100416023.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if b2 and Duel.SelectYesNo(tp,aux.Stringid(100416023,1)) then
		Duel.BreakEffect()
		c100416023.specialsummon(e,tp,eg,ep,ev,re,r,rp)
	end
	if b3 and Duel.SelectYesNo(tp,aux.Stringid(100416023,2)) then
		Duel.BreakEffect()
		c100416023.destroy(e,tp,eg,ep,ev,re,r,rp)
	end
end
function c100416023.place(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_PZONE,0,1,1,nil)
	if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg=Duel.SelectMatchingCard(tp,c100416023.tpfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		local tc=sg:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
function c100416023.specialsummon(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100416023.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
function c100416023.destroy(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
