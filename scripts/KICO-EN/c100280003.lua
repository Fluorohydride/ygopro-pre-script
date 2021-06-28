--大王小王
function c100280003.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100280003,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100280003)
	e1:SetCondition(c100280003.spcon)
	e1:SetCost(c100280003.spcost)
	e1:SetTarget(c100280003.sptg)
	e1:SetOperation(c100280003.spop)
	c:RegisterEffect(e1)
end
function c100280003.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c100280003.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1
end
function c100280003.thfilter(c)
	if not (c:IsCode(64788463) or c:IsCode(25652259) or c:IsCode(90876561)) then return false end
	return c:IsAbleToHand()
end
function c100280003.spfilter(c,e,tp)
	if not (c:IsCode(64788463) or c:IsCode(25652259) or c:IsCode(90876561)) then return false end
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100280003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		local g1=Duel.GetMatchingGroup(c100280003.thfilter,tp,LOCATION_DECK,0,nil)
		local g2=Duel.GetMatchingGroup(c100280003.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		return (g1:GetClassCount(Card.GetCode)>=2 or (not Duel.IsPlayerAffectedByEffect(tp,59822133) and ft>0 and g2:GetClassCount(Card.GetCode)>=2)) end
end
function c100280003.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g1=Duel.GetMatchingGroup(c100280003.thfilter,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c100280003.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	local b1=g1:GetClassCount(Card.GetCode)>1
	local b2=not Duel.IsPlayerAffectedByEffect(tp,59822133) and g2:GetClassCount(Card.GetCode)>1 and ft>1
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,1190,1152)
	elseif b1 then op=0
	elseif b2 then op=1
	else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=g1:SelectSubGroup(tp,aux.dncheck,false,2,2)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=g2:SelectSubGroup(tp,aux.dncheck,false,2,2)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end







