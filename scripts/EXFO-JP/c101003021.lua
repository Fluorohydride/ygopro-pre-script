--星遺物－『星盾』
--World Legacy - "World Shield"
--Scripted by Eerie Code
function c101003021.initial_effect(c)
	--Cannot activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(c101003021.aclimit)
	c:RegisterEffect(e1)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetCondition(c101003021.indcon)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c101003021.indcon)
	e3:SetValue(c101003021.indval)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101003021,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,101003021)
	e4:SetCost(c101003021.spcost)
	e4:SetTarget(c101003021.sptg)
	e4:SetOperation(c101003021.spop)
	c:RegisterEffect(e4)
end
function c101003021.aclimit(e,re,tp)
	local tc=re:GetHandler()
	return tc:IsLocation(LOCATION_MZONE) and tc:GetSummonLocation()==LOCATION_EXTRA and re:IsActiveType(TYPE_MONSTER) and not tc:IsImmuneToEffect(e)
end
function c101003021.indfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xfe) and c:IsControler(tp)
end
function c101003021.indcon(e)
	local tp=e:GetHandlerPlayer()
	return e:GetHandler():GetColumnGroup():IsExists(c101003021.indfilter,1,e:GetHandler(),tp)
end
function c101003021.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end
function c101003021.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c101003021.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101003021.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101003021.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(c101003021.spfilter,1-tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
		if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
			and g:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(101003021,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.SpecialSummon(sg,0,1-tp,1-tp,false,false,POS_FACEUP)
		end
	end
end
