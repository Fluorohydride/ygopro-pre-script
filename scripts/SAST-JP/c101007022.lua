--プランキッズ・ロック
--Planckster Rock
function c101007022.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101007022,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101007022)
	e1:SetCondition(c101007022.reccon)
	e1:SetTarget(c101007022.rectg)
	e1:SetOperation(c101007022.recop)
	c:RegisterEffect(e1)
end
function c101007022.reccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	return c:IsLocation(LOCATION_GRAVE) and rc:IsSetCard(0x120) and r&REASON_FUSION+REASON_LINK~=0
end
function c101007022.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
			and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK+LOCATION_HAND)
end
function c101007022.spfilter(c,e,tp)
	return c:IsSetCard(0x120) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and not c:IsCode(101007022)
end
function c101007022.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.GetMatchingGroup(c101007022.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp)
	local rc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,1,nil)
	if #rc>0 and Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)>0 and Duel.Draw(tp,1,REASON_EFFECT)>0
		and #g>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(101007022,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
