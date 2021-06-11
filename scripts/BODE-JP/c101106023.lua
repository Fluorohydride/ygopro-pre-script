--しらうおの軍貫
--scripted by XyLeN
function c101106023.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101106023,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101106023)
	e1:SetCondition(c101106023.spcon)
	e1:SetTarget(c101106023.sptg)
	e1:SetOperation(c101106023.spop)
	c:RegisterEffect(e1)
	--spsummon2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101106023,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101106023+100)
	e2:SetTarget(c101106023.sptg2)
	e2:SetOperation(c101106023.spop2)
	c:RegisterEffect(e2)
end
function c101106023.cfilter(c)
	local oc=c:GetOverlayGroup()
	return (oc and oc:IsExists(Card.IsCode,1,nil,24639891) and c:IsType(TYPE_XYZ) or c:IsCode(24639891))
end
function c101106023.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101106023.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101106023.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101106023.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101106023.spfilter(c,e,tp)
	return c:IsSetCard(0x166) and not c:IsCode(101106023) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101106023.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101106023.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c101106023.filter(c) 
	return c:IsCode(24639891) and c:IsAbleToDeck()
end
function c101106023.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101106023.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c101106023.filter),tp,LOCATION_GRAVE+LOCATION_DECK,0,nil)
		if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(101106023,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local dg=sg:Select(tp,1,#sg,nil)
			Duel.BreakEffect()
			local tc=dg:GetFirst() 
			while tc do
				if tc:IsLocation(LOCATION_GRAVE) then
					Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
				end
				Duel.MoveSequence(tc,0)
				tc=dg:GetNext()
			end
			Duel.SortDecktop(tp,tp,#dg)
		end
	end
end
