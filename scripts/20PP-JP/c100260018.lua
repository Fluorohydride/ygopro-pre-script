--白の水鏡

--Scripted by mallu11
function c100260018.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100260018+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100260018.target)
	e1:SetOperation(c100260018.activate)
	c:RegisterEffect(e1)
end
function c100260018.filter(c,e,tp)
	return c:IsLevelAbove(1) and c:IsLevelBelow(4) and c:IsRace(RACE_FISH) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100260018.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and c100260018.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c100260018.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c100260018.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100260018.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c100260018.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local code=tc:GetOriginalCode()
		if Duel.IsExistingMatchingCard(c100260018.thfilter,tp,LOCATION_DECK,0,1,nil,code)
			and Duel.SelectYesNo(tp,aux.Stringid(100260018,0)) then
			local hc=Duel.GetFirstMatchingCard(c100260018.thfilter,tp,LOCATION_DECK,0,nil,code)
			if hc then
				Duel.SendtoHand(hc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,hc)
			end
		end
	end
end
