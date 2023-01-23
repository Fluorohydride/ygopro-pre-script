--百檎龍－リンゴブルム
--Script by 奥克斯
function c101112029.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101112029)
	e1:SetCondition(c101112029.spcon)
	e1:SetTarget(c101112029.sptg)
	e1:SetOperation(c101112029.spop)
	c:RegisterEffect(e1)   
	--token
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101112029+100)
	e2:SetCondition(c101112029.tkcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101112029.tktg)
	e2:SetOperation(c101112029.tkop)
	c:RegisterEffect(e2)
	if not c101112029.global_check then
		c101112029.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetCondition(c101112029.checkcon)
		ge1:SetOperation(c101112029.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c101112029.checkfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c101112029.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101112029.checkfilter,1,nil)
end
function c101112029.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c101112029.checkfilter,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),101112029,RESET_PHASE+PHASE_END,0,1)
		tc=g:GetNext()
	end
end
function c101112029.spcfilter(c)
	return not c:IsType(TYPE_EFFECT) and c:IsFaceup()
end
function c101112029.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101112029.spcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c101112029.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101112029.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c101112029.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,101112029)>0
end
function c101112029.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,101112129,0,TYPES_TOKEN_MONSTER,100,100,2,RACE_WYRM,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c101112029.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,101112129,0,TYPES_TOKEN_MONSTER,100,100,2,RACE_WYRM,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,101112129)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_NONTUNER)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(c101112029.tnval)
		token:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
end
function c101112029.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler())
end