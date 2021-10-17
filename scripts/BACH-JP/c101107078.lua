--ドライブ・ドライブ
--
--Script by Trishula9
function c101107078.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101107078+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101107078.target)
	e1:SetOperation(c101107078.operation)
	c:RegisterEffect(e1)
end
function c101107078.filter(c,e,tp,race)
	return c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false)) and c:IsRace(race)
end
function c101107078.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local ct=mg:GetClassCount(Card.GetRace)
	local mc=mg:GetFirst()
	local mrc=0
	while mc do
		mrc=mrc|mc:GetRace()
		mc=mg:GetNext()
	end
	local g=Duel.GetMatchingGroup(c101107078.filter,tp,LOCATION_DECK,0,nil,e,tp,mrc)
	if chk==0 then return ct>=3 and g:CheckSubGroup(aux.drccheck,3,3) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101107078.operation(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local ct=mg:GetClassCount(Card.GetRace)
	local mc=mg:GetFirst()
	local mrc=0
	while mc do
		mrc=mrc|mc:GetRace()
		mc=mg:GetNext()
	end
	local g=Duel.GetMatchingGroup(c101107078.filter,tp,LOCATION_DECK,0,nil,e,tp,mrc)
	if ct<3 or not g:CheckSubGroup(aux.drccheck,3,3) then return end		
	local sg=g:SelectSubGroup(tp,aux.drccheck,false,3,3)
	if #sg>0 then
		Duel.ConfirmCards(1-tp,sg)
		local tc=sg:RandomSelect(1-tp,1):GetFirst()
		Duel.ConfirmCards(tp,tc)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.SelectYesNo(tp,aux.Stringid(101107078,0)) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end		
		sg:RemoveCard(tc)
		Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
		Duel.SortDecktop(p,p,2)
		for i=1,2 do
			local mg=Duel.GetDecktopGroup(p,1)
			Duel.MoveSequence(mg:GetFirst(),1)
		end
	end
end