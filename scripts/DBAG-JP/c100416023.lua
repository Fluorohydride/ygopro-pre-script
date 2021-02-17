--ドレミコード・スケール

--scripted by Xylen5967
function c100416023.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
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
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x265) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c100416023.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_PZONE,0,1,nil,TYPE_PENDULUM) and Duel.IsExistingMatchingCard(c100416023.tpfilter,tp,LOCATION_EXTRA,0,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)>0
	local b2=Duel.IsExistingMatchingCard(c100416023.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b3=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	local g=Duel.GetMatchingGroup(c100416023.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	if chk==0 then return ((ct>=3 and b1) or (ct>=5 and b2) or (ct>=7 and b3)) end
	local res=Group.CreateGroup()
	if ct>=3 and b1 and ((b2 and b3) or Duel.SelectYesNo(tp,aux.Stringid(100416023,0))) then
		c100416023.place(e,tp,eg,ep,ev,re,r,rp)
	end
	if ct>=5 and b2 and ((#res==0 and b3) or Duel.SelectYesNo(tp,aux.Stringid(100416023,1))) then
		c100416023.specialsummon(e,tp,eg,ep,ev,re,r,rp)
	end
	if ct>=7 and b3 and (#res==0 or Duel.SelectYesNo(tp,aux.Stringid(100416023,2))) then
		c100416023.destroy(e,tp,eg,ep,ev,re,r,rp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c100416023.place(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_PZONE,0,1,1,nil,TYPE_PENDULUM)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
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
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100416023.destroy(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
