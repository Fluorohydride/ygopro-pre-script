--Sin パラドクスギア
--
--Script by mercury233
function c100236115.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100236115+100)
	e1:SetCondition(c100236115.condition)
	e1:SetCost(c100236115.cost)
	e1:SetTarget(c100236115.target)
	e1:SetOperation(c100236115.operation)
	c:RegisterEffect(e1)
	--replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(100236115)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCountLimit(1,100236115)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c100236115.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function c100236115.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c100236115.spfilter(c,e,tp)
	return c:IsCode(74509280) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c100236115.thfilter,tp,LOCATION_DECK,0,1,c)
end
function c100236115.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x23) and c:IsAbleToHand() and not c:IsCode(100236115)
end
function c100236115.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(c100236115.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c100236115.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c100236115.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g1:GetCount()>0 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,c100236115.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g2:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(g2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
		end
	end
end
