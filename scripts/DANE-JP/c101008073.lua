--虹の天気模様
--
--Script by mercury233
function c101008073.initial_effect(c)
	c:SetUniqueOnField(1,0,101008073)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101008073,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101008073.spcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101008073.sptg)
	e2:SetOperation(c101008073.spop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c101008073.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c101008073.eftg(e,c)
	local seq=c:GetSequence()
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x109)
		and seq<5 and math.abs(e:GetHandler():GetSequence()-seq)<=1
end
function c101008073.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c101008073.spfilter(c,e,tp,code)
	return c:IsSetCard(0x109) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101008073.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c101008073.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,e:GetHandler():GetCode()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101008073.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c101008073.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,e:GetHandler():GetCode())
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101008073.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c101008073.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_DECK)
end
