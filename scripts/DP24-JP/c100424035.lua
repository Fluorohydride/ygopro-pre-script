--宇宙の法則

--Scripted by mallu11
function c100424035.initial_effect(c)
	aux.AddCodeList(c,77585513)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100424035,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100424035+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100424035.target)
	e1:SetOperation(c100424035.activate)
	c:RegisterEffect(e1)
end
function c100424035.spfilter(c,e,tp)
	return c:IsCode(77585513) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100424035.thfilter(c)
	return (c:IsCode(77585513) or aux.IsCodeListed(c,77585513) and c:IsType(TYPE_MONSTER)) and c:IsAbleToHand()
end
function c100424035.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c100424035.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(c100424035.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end
function c100424035.setfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSSetable(true)
end
function c100424035.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100424035.setfilter,tp,0,LOCATION_HAND+LOCATION_DECK,nil)
	if g:GetCount()>0 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(1-tp,aux.Stringid(100424035,0)) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SET)
		local sg=g:Select(1-tp,1,1,nil)
		if Duel.SSet(1-tp,sg)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local pg=Duel.SelectMatchingCard(tp,c100424035.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if pg:GetCount()>0 then
				Duel.SpecialSummon(pg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hg=Duel.SelectMatchingCard(tp,c100424035.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if hg:GetCount()>0 then
			Duel.SendtoHand(hg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,hg)
		end
	end
end
