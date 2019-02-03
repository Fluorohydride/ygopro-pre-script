--Valkyrie Sechste
--Script by JoyJ
function c101007088.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101007088,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101007088)
	e1:SetTarget(c101007088.SpecialSummonSuccessTarget)
	e1:SetOperation(c101007088.SpecialSummonSuccessOperation)
	c:RegisterEffect(e1)
	--gy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101007088,1))
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101007088+1)
	e2:SetTarget(c101007088.SendToGraveTarget)
	e2:SetOperation(c101007088.SendToGraveOperation)
	c:RegisterEffect(e2)
end
function c101007088.SendToGraveOperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(1-tp,2,REASON_EFFECT)
end
function c101007088.SendToGraveTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(1-tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,2)
end
function c101007088.SpecialSummonSuccessFilter(c,e,tp)
	return c:IsSetCard(0x122) and (not c:IsCode(101007088)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101007088.SpecialSummonSuccessOperation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE) < 1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101007088.SpecialSummonSuccessFilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount() > 0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101007088.SpecialSummonSuccessTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE) > 0
		and Duel.IsExistingMatchingCard(c101007088.SpecialSummonSuccessFilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
