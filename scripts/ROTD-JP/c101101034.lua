--レッドポータン
--
--Scripted by:零界
function c101101034.initial_effect(c)
	--tuner
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101101034)
	e1:SetTarget(c101101034.chtg)
	e1:SetOperation(c101101034.chop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101101034+100)
	e2:SetCondition(c101101034.spcon)
	e2:SetTarget(c101101034.sptg)
	e2:SetOperation(c101101034.spop)
	c:RegisterEffect(e2)
end
function c101101034.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x250) and not c:IsType(TYPE_TUNER)
end
function c101101034.chtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101101034.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101101034.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101101034.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101101034.chop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(TYPE_TUNER)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	tc:RegisterEffect(e1)
end
function c101101034.confil(c,tp)
	return (c:GetSummonPlayer()==tp or c:GetSummonPlayer()==1-tp) and c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c101101034.spfilter(c,e,tp)
	return c:IsSetCard(0x250) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101101034.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101101034.confil,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c101101034.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101101034.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c101101034.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101101034.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
