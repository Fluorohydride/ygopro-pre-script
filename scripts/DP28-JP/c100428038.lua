--バーニングナックル・クロスカウンター

--Script by Chrono-Genex
function c100428038.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,100428038+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100428038.condition)
	e1:SetTarget(c100428038.target)
	e1:SetOperation(c100428038.activate)
	c:RegisterEffect(e1)
end
function c100428038.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c100428038.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x48,0x1084) and c:IsType(TYPE_XYZ)
end
function c100428038.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100428038.desfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	local g=Duel.GetMatchingGroup(c100428038.desfilter,tp,LOCATION_MZONE,0,nil)
	local ct=1
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		g:Merge(eg)
		ct=ct+1
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,ct,0,0)
end
function c100428038.spfilter(c,e,tp,code)
	return c:IsSetCard(0x1084) and c:IsType(TYPE_XYZ) and not c:IsOriginalCodeRule(code)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c100428038.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,c100428038.desfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=dg:GetFirst()
	if tc then
		Duel.HintSelection(dg)
		if Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.NegateActivation(ev)
			and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
			local c=e:GetHandler()
			local g=Duel.GetMatchingGroup(c100428038.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,tc:GetOriginalCode())
			if g:GetCount()>0 and c:IsRelateToChain() and c:IsCanOverlay()
				and Duel.SelectYesNo(tp,aux.Stringid(100428038,0)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g:Select(tp,1,1,nil)
				if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 then
					c:CancelToGrave()
					Duel.Overlay(tc,c)
				end
			end
		end
	end
end
