--天幻の龍輪

--Scripted by mallu11
function c101101066.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101101066,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,101101066)
	e1:SetCost(c101101066.cost)
	e1:SetTarget(c101101066.target)
	e1:SetOperation(c101101066.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101101066,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101101066)
	e2:SetCondition(c101101066.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101101066.thtg)
	e2:SetOperation(c101101066.thop)
	c:RegisterEffect(e2)
end
function c101101066.filter(c,e,tp,check)
	return c:IsRace(RACE_WYRM) and (Duel.IsExistingMatchingCard(c101101066.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		or (check and not c:IsType(TYPE_EFFECT)
		and Duel.IsExistingMatchingCard(c101101066.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp,true)
		and Duel.GetMZoneCount(tp,c)>0))
end
function c101101066.thfilter(c,e,tp,check)
	return c:IsRace(RACE_WYRM) and (c:IsAbleToHand() or (check and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c101101066.thfilter2(c,e,tp,ft,check)
	return c:IsRace(RACE_WYRM) and (c:IsAbleToHand() or (check and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ft>0))
end
function c101101066.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100,0)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101101066.filter,1,nil,e,tp,true) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c101101066.filter,1,1,nil,e,tp,true)
	if not g:GetFirst():IsType(TYPE_EFFECT) then e:SetLabel(100,1) end
	Duel.Release(g,REASON_COST)
end
function c101101066.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local check=true
	local l1,l2=e:GetLabel()
	if chk==0 then
		if l1~=100 then check=false end
		e:SetLabel(0,0)
		return Duel.IsExistingMatchingCard(c101101066.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp,check)
	end
	if l2==1 and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c101101066.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local check=false
	local l1,l2=e:GetLabel()
	if l2==1 and e:IsHasType(EFFECT_TYPE_ACTIVATE) then check=true end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101101066,2))
	local g=Duel.SelectMatchingCard(tp,c101101066.thfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,ft,check)
	local tc=g:GetFirst()
	if tc then
		if not check or (tc:IsAbleToHand() and (ft<=0 or not tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			or Duel.SelectOption(tp,1190,1152)==0)) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
			Duel.SpecialSummonComplete()
		end
	end
end
function c101101066.ffilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_EFFECT)
end
function c101101066.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101101066.ffilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101101066.cfilter(c)
	return c:IsSetCard(0x12c) and c:IsAbleToHand()
end
function c101101066.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c101101066.cfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101101066.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101101066.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
