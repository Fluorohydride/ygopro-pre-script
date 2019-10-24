--オッドアイズ・ウィザード・ドラゴン

--Scripted by mallu11
function c100423046.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100423046,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c100423046.spcost)
	e1:SetTarget(c100423046.sptg)
	e1:SetOperation(c100423046.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100423046,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCost(c100423046.thcon)
	e2:SetTarget(c100423046.thtg)
	e2:SetOperation(c100423046.thop)
	c:RegisterEffect(e2)
end
function c100423046.cfilter(c,tp)
	return c:IsAttribute(ATTRIBUTE_DARK)
	and (c:GetSequence()>4 and Duel.IsExistingMatchingCard(c100423046.filter1,tp,LOCATION_MZONE,0,1,c,tp)
	or (Duel.GetMZoneCount(tp,c)>0 and Duel.IsExistingMatchingCard(c100423046.filter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE,0,1,c)))
end
function c100423046.filter1(c,tp)
	return c:IsCode(53025096) and c:IsAbleToGrave() and c:IsFaceup() and Duel.GetMZoneCount(tp,c)>0
end
function c100423046.filter2(c)
	return c:IsCode(53025096) and c:IsAbleToGrave() and (c:IsFaceup() or c:IsLocation(LOCATION_HAND+LOCATION_DECK))
end
function c100423046.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c100423046.cfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c100423046.cfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c100423046.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100423046.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		g=Duel.SelectMatchingCard(tp,c100423046.filter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	else
		g=Duel.SelectMatchingCard(tp,c100423046.filter2,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	end
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100423046.spfilter(c,e,tp)
	return c:IsSetCard(0x99) and not c:IsCode(100423046) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100423046.thfilter(c)
	return c:IsCode(82768499) and c:IsAbleToHand()
end
function c100423046.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousControler()==tp and c:IsReason(REASON_DESTROY) and rp==1-tp
end
function c100423046.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100423046.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100423046.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_OPSELECTED,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100423046.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0
			and Duel.IsExistingMatchingCard(c100423046.thfilter,tp,LOCATION_DECK,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(100423046,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg=Duel.SelectMatchingCard(tp,c100423046.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
