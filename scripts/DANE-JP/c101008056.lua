--超量要請アルファンコール
--
--Script by mercury233
function c101008056.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCountLimit(1,101008056+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101008056.condition)
	e1:SetTarget(c101008056.target)
	e1:SetOperation(c101008056.activate)
	c:RegisterEffect(e1)
end
function c101008056.cfilter(c,tp)
	return c:IsSetCard(0xdc) and c:GetPreviousControler()==tp
end
function c101008056.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101008056.cfilter,1,nil,tp)
end
function c101008056.spfilter(c,e,tp)
	return c:IsSetCard(0x20dc) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101008056.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c101008056.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101008056.spfilter2(c,e,tp,mc)
	return c:IsSetCard(0x10dc) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and aux.IsCodeListed(mc,c:GetCode())
end
function c101008056.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c101008056.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c101008056.spfilter2),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp,tc)
		if #g2<=0 or not Duel.SelectYesNo(tp,aux.Stringid(101008056,0)) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc2=g2:Select(tp,1,1,nil):GetFirst()
		if tc2 and Duel.SpecialSummonStep(tc2,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc2:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc2:RegisterEffect(e2)
		end
		Duel.SpecialSummonComplete()
	end
end
