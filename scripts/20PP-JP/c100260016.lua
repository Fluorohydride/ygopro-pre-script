--ペンデュラム・エクシーズ

--Scripted by mallu11
function c100260016.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100260016+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c100260016.cost)
	e1:SetTarget(c100260016.target)
	e1:SetOperation(c100260016.operation)
	c:RegisterEffect(e1)
end
function c100260016.lvfilter(c,e,tp)
	return c:IsLevelAbove(1) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100260016.spfilter(c,e,tp)
	return c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100260016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(c100260016.spfilter,tp,LOCATION_PZONE,0,nil,e,tp)
	local g=sg:Filter(Card.IsLevelAbove,nil,1)
	local cg=nil
	if g:GetCount()==2 then
		local tc=g:GetFirst()
		while tc do
			cg=g:Filter(aux.TRUE,tc)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_XYZ_LEVEL)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetLabel(cg:GetFirst():GetLevel())
			e1:SetValue(c100260016.xyzlv)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,nil,sg,2,2) end
end
function c100260016.xyzlv(e,c,rc)
	return e:GetLabel()+e:GetHandler():GetLevel()*65536
end
function c100260016.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c100260016.spfilter,tp,LOCATION_PZONE,0,nil,e,tp)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.GetLocationCountFromEx(tp)>0 and g:GetCount()==2 end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_PZONE)
end
function c100260016.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 or sg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if sg and sg:GetCount()==2 then
		local tc1=sg:GetFirst()
		local tc2=sg:GetNext()
		Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonStep(tc2,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc1:RegisterEffect(e1)
		local e2=e1:Clone()
		tc2:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc1:RegisterEffect(e3)
		local e4=e3:Clone()
		tc2:RegisterEffect(e4)
		Duel.SpecialSummonComplete()
		if Duel.GetLocationCountFromEx(tp,tp,sg)<=0 then return end
		local cg=nil
		if sg:FilterCount(Card.IsLevelAbove,nil,1)==2 then
			local tc=sg:GetFirst()
			while tc do
				cg=sg:Filter(aux.TRUE,tc)
				local e5=Effect.CreateEffect(e:GetHandler())
				e5:SetType(EFFECT_TYPE_SINGLE)
				e5:SetCode(EFFECT_XYZ_LEVEL)
				e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e5:SetLabel(cg:GetFirst():GetLevel())
				e5:SetValue(c100260016.xyzlv)
				e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
				tc:RegisterEffect(e5)
				tc=sg:GetNext()
			end
		end
		local xyzg=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,sg,2,2)
		if xyzg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
			Duel.XyzSummon(tp,xyz,sg)
		end
	end
end
