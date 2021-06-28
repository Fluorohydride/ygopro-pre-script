--磁力感应
function c100280009.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100280009+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100280009.spcon)
	e1:SetTarget(c100280009.sptg)
	e1:SetOperation(c100280009.spop)
	c:RegisterEffect(e1)	
end
function c100280009.cpfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2066) and c:GetOriginalLevel()<=4
end
function c100280009.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100280009.cpfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100280009.cfilter2(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c100280009.spfilter(c,e,tp)
	return c:IsSetCard(0x2066) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not Duel.IsExistingMatchingCard(c100280009.cfilter2,tp,LOCATION_ONFIELD,0,1,nil,c:GetCode())
end
function c100280009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100280009.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c100280009.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
        --change damage
        local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
        e1:SetTarget(c100280009.indtg)
		e1:SetValue(1)
        Duel.RegisterEffect(e1,tp)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
        e2:SetValue(aux.indoval)
        Duel.RegisterEffect(e2,tp)
    end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100280009.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100280009.indtg(e,c)
    return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x2066) or c:IsSetCard(0xe9)) and c:IsFaceup()
end