--サイバネティック・ホライゾン

--Scripted by mallu11
function c100341053.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100341053+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c100341053.cost)
	e1:SetTarget(c100341053.target)
	e1:SetOperation(c100341053.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(100341053,ACTIVITY_SPSUMMON,c100341053.counterfilter)
end
function c100341053.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsRace(RACE_MACHINE)
end
function c100341053.costfilter(c)
	return c:IsRace(RACE_DRAGON+RACE_MACHINE) and c:IsSetCard(0x93) and c:IsAbleToGraveAsCost()
end
function c100341053.thfilter(c)
	return c:IsRace(RACE_DRAGON+RACE_MACHINE) and c:IsSetCard(0x93) and c:IsAbleToHand()
end
function c100341053.fselect(g,tp)
	local sg=g:Clone()
	local res=true
	for c in aux.Next(sg) do
		res=res and not sg:IsExists(Card.IsAttribute,1,c,c:GetAttribute())
	end
	return g:GetClassCount(Card.GetLocation)==g:GetCount() and res and Duel.IsExistingMatchingCard(c100341053.thfilter,tp,LOCATION_DECK,0,1,g)
end
function c100341053.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c100341053.costfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	if chk==0 then return Duel.GetCustomActivityCount(100341053,tp,ACTIVITY_SPSUMMON)==0 and g:CheckSubGroup(c100341053.fselect,2,2,tp) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c100341053.splimit)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,c100341053.fselect,false,2,2,tp)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c100341053.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsRace(RACE_MACHINE)
end
function c100341053.tgfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsSetCard(0x93) and c:IsType(TYPE_FUSION) and c:IsAbleToGrave()
end
function c100341053.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100341053.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c100341053.tgfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c100341053.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c100341053.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c100341053.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
