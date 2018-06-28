--Contact Gate
--Script by dest
function c101005000.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101005000+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c101005000.cost)
	e1:SetTarget(c101005000.target)
	e1:SetOperation(c101005000.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101005000,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c101005000.spcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101005000.sptg)
	e2:SetOperation(c101005000.spop)
	c:RegisterEffect(e2)
end
function c101005000.cfilter1(c,e,tp)
	return c:IsSetCard(0x1f) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c101005000.cfilter2,tp,LOCATION_GRAVE,0,1,c,e,tp,c)
end
function c101005000.cfilter2(c,e,tp,tc)
	if c:IsCode(tc:GetCode()) then return false end
	local sg=Group.FromCards(tc,c)
	local g=Duel.GetMatchingGroup(c101005000.spfilter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,sg,e,tp)
	return c:IsSetCard(0x1f) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and g:GetClassCount(Card.GetCode)>1
end
function c101005000.spfilter1(c,e,tp)
	return c:IsSetCard(0x1f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101005000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101005000.cfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c101005000.cfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c101005000.cfilter2,tp,LOCATION_GRAVE,0,1,1,g1:GetFirst(),e,tp,g1:GetFirst())
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c101005000.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c101005000.spfilter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and g:GetClassCount(Card.GetCode)>1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c101005000.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101005000.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c101005000.spfilter1),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if g:GetClassCount(Card.GetCode)>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=g:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101005000.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_FUSION) and c:IsLocation(LOCATION_EXTRA)
end
function c101005000.confilter(c,tp)
	return aux.IsMaterialListCode(c,89943723) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and c:IsLocation(LOCATION_EXTRA)
end
function c101005000.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101005000.confilter,1,nil,tp)
end
function c101005000.spfilter2(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x1f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101005000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101005000.spfilter2,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c101005000.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101005000.spfilter2,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
