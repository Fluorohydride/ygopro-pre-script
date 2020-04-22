--Goldenhair, the Newest Plunder Patroll
--
--Script by JoyJ
function c101012086.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101012086,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101012086)
	e1:SetCost(c101012086.spcost)
	e1:SetTarget(c101012086.sptg)
	e1:SetOperation(c101012086.spop)
	c:RegisterEffect(e1)
	--special summon from grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33420078,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101012086+100)
	e2:SetCost(c101012086.cost)
	e2:SetTarget(c101012086.target)
	e2:SetOperation(c101012086.operation)
	c:RegisterEffect(e2)
end
function c101012086.cfilter(c,tp)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0x13f) and c:IsType(TYPE_MONSTER)
		and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and Duel.GetMZoneCount(tp,c)>0
end
function c101012086.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101012086.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101012086.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,e:GetHandler(),tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c101012086.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101012086.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c101012086.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c101012086.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101012086.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101012086.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101012086.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x13f)
end
