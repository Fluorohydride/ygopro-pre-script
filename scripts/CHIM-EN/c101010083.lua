--Tyrant Farm

--Scripted by mallu11
function c101010083.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101010083+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c101010083.cost)
	e1:SetTarget(c101010083.target)
	e1:SetOperation(c101010083.activate)
	c:RegisterEffect(e1)
end
function c101010083.cfilter(c,e,tp)
	return c:IsType(TYPE_EFFECT) and Duel.IsExistingMatchingCard(c101010083.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp,c:GetOriginalRace(),c:GetOriginalAttribute()) and Duel.GetMZoneCount(tp,c)>0
end
function c101010083.spfilter(c,e,tp,race,att)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_EFFECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetOriginalRace()==race and c:GetOriginalAttribute()==att
end
function c101010083.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c101010083.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c101010083.cfilter,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c101010083.cfilter,1,1,nil,e,tp)
	Duel.Release(g,REASON_COST)
	g:KeepAlive()
	e:SetLabelObject(g:GetFirst())
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c101010083.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=e:GetLabelObject()
	local race=tc:GetOriginalRace()
	local att=tc:GetOriginalAttribute()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101010083.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,race,att)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
