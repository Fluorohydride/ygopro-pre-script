--満天禍コルドー

--Script by nekrozar
function c101009030.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101009030,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101009030)
	e1:SetCondition(c101009030.spcon)
	e1:SetTarget(c101009030.sptg)
	e1:SetOperation(c101009030.spop)
	c:RegisterEffect(e1)
end
function c101009030.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousPosition(POS_FACEUP) and bit.band(c:GetPreviousAttributeOnField(),ATTRIBUTE_WIND)~=0
		and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp)
end
function c101009030.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101009030.cfilter,1,nil,tp)
end
function c101009030.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101009030.tdfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeck()
end
function c101009030.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c101009030.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0
		and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101009030,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,1,nil)
		Duel.BreakEffect()
		Duel.HintSelection(sg)
		Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
	end
end
