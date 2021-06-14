--ティンクル・ファイブスター
--
--Script by mercury233
function c100278006.initial_effect(c)
	aux.AddCodeList(c,40640057)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100278006+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c100278006.cost)
	e1:SetTarget(c100278006.target)
	e1:SetOperation(c100278006.activate)
	c:RegisterEffect(e1)
end
c100278006.spchecks=aux.CreateChecks(Card.IsCode,{100278001,100278002,100278003,100278004,40640057})
function c100278006.cfilter(c,tp)
	return c:IsFaceup() and c:IsLevel(5) and c:IsReleasable() and Duel.GetMZoneCount(tp,c)>=5
end
function c100278006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)~=1 then return false end
	local rc=Duel.GetFirstMatchingCard(c100278006.cfilter,tp,LOCATION_MZONE,0,nil,tp)
	if chk==0 then return rc end
	Duel.Release(rc,REASON_COST)
end
function c100278006.spfilter(c,e,tp)
	return c:IsCode(100278001,100278002,100278003,100278004,40640057) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100278006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=e:GetLabel()==1 or Duel.GetLocationCount(tp,LOCATION_MZONE)>=5
	if chk==0 then
		e:SetLabel(0)
		local g=Duel.GetMatchingGroup(c100278006.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
		return res and not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and g:CheckSubGroupEach(c100278006.spchecks)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,5,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c100278006.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>=5 and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100278006.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroupEach(tp,c100278006.spchecks,false)
		if sg then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			for tc in aux.Next(sg) do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UNRELEASABLE_SUM)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(1)
				tc:RegisterEffect(e1,true)
			end
		end
	end
end
