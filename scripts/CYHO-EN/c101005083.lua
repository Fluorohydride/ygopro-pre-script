--Danger! Nessie!
--Script by dest
function c101005083.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101005083,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c101005083.spcost)
	e1:SetTarget(c101005083.sptg)
	e1:SetOperation(c101005083.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101005083,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DISCARD)
	e2:SetCountLimit(1,101005083)
	e2:SetTarget(c101005083.thtg)
	e2:SetOperation(c101005083.thop)
	c:RegisterEffect(e2)
end
function c101005083.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c101005083.spfilter(c,e,tp)
	return c:IsCode(101005083) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101005083.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(c101005083.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c101005083.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if g:GetCount()<=0 then return end
	local tc=g:RandomSelect(1-tp,1):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_DISCARD+REASON_EFFECT)~=0 and not tc:IsCode(101005083)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local spg=Duel.GetMatchingGroup(c101005083.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
		if spg:GetCount()<=0 then return end
		local sg=spg:GetFirst()
		if spg:GetCount()~=1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sg=spg:Select(tp,1,1,nil)
		end
		Duel.BreakEffect()
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c101005083.thfilter(c)
	return c:IsSetCard(0x223) and not c:IsCode(101005083) and c:IsAbleToHand()
end
function c101005083.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101005083.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101005083.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101005083.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
