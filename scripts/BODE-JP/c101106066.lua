--天斗輝巧極
--Ursarctic Drytron
--scripted by XyLeN
function c101106066.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101106066.target)
	e1:SetOperation(c101106066.activate)
	c:RegisterEffect(e1)
	--replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(101106066)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101106066)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(16471775)
	c:RegisterEffect(e3)
end
function c101106066.deckconfilter(c)
	return c:IsCode(97148796,27693363) and c:IsFaceup()
end
function c101106066.deckcon(tp)
	return Duel.IsExistingMatchingCard(c101106066.deckconfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101106066.cfilter(c)
	return c:IsCode(89264428,58793369) and c:IsAbleToRemove()
end
function c101106066.fselect(g,e,tp)
	return g:GetClassCount(Card.GetCode)==2 and g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
		and Duel.IsExistingMatchingCard(c101106066.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,g)
end
function c101106066.spfilter(c,e,tp,g)
	return c:IsCode(101106040) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and Duel.GetLocationCountFromEx(tp,tp,g,c)>0
end
function c101106066.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_ONFIELD
	if c101106066.deckcon(tp) then loc=loc|LOCATION_DECK end
	local g=Duel.GetMatchingGroup(c101106066.cfilter,tp,loc,0,nil)
	if chk==0 then return g:CheckSubGroup(c101106066.fselect,2,2,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101106066.activate(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_HAND+LOCATION_ONFIELD
	if c101106066.deckcon(tp) then loc=loc|LOCATION_DECK end
	local g=Duel.GetMatchingGroup(c101106066.cfilter,tp,loc,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:SelectSubGroup(tp,c101106066.fselect,false,2,2,e,tp)
	if rg and Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c101106066.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil)
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end
