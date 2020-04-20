--红面波波
function c101101034.initial_effect(c)
	--be tuner
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101101034,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101101034)
	e1:SetTarget(c101101034.ttg)
	e1:SetOperation(c101101034.top)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101101034,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101101034+100)
	e2:SetCondition(c101101034.descon)
	e2:SetTarget(c101101034.destg)
	e2:SetOperation(c101101034.desop)
	c:RegisterEffect(e2)
end
function c101101034.tfilter(c)
	return (not c:IsType(TYPE_TUNER))
end
function c101101034.ttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c101101034.tfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SelectTarget(tp,c101101034.tfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101101034.top(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
	end
end
function c101101034.spfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c101101034.spfilter2(c,e,tp)
	return c:IsSetCard(0x250) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101101034.descon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c101101034.spfilter)
end
function c101101034.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101101034.spfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c101101034.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.SelectMatchingCard(tp,c101101034.spfilter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if c then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end