--遊覧艇サブマリード
--
--Script by Trishula9
function c101107027.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101107027)
	e1:SetCondition(c101107027.spcon)
	e1:SetTarget(c101107027.sptg)
	e1:SetOperation(c101107027.spop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c101107027.indtg)
	e2:SetCountLimit(1)
	e2:SetValue(c101107027.indct)
	c:RegisterEffect(e2)
end
function c101107027.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
end
function c101107027.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101107027.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c101107027.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101107027.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101107027.indtg(e,c)
	return c:IsType(TYPE_NORMAL) and c:IsFaceup()
end
function c101107027.indct(e,re,r,rp)
	local a,d=Duel.GetBattleMonster(tp)
	return bit.band(r,REASON_BATTLE)~=0 and d and d:IsType(TYPE_EFFECT)
end