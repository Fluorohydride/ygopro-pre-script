--真の光
--
--Scripted by KillerDJ
function c100281064.initial_effect(c)
	aux.AddCodeList(c,89631139)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--select effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,100281064)
	e2:SetTarget(c100281064.target)
	e2:SetOperation(c100281064.operation)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsCode,89631139))
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100281064,3))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c100281064.descon)
	e4:SetTarget(c100281064.destg)
	e4:SetOperation(c100281064.desop)
	c:RegisterEffect(e4)
end
function c100281064.cfilter(c,code)
	return c:IsCode(code) and (c:IsFaceup() or not c:IsOnField())
end
function c100281064.filter1(c,e,tp)
	return c:IsCode(89631139) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100281064.filter2(c)
	return aux.IsCodeListed(c,89631139) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
		and not Duel.IsExistingMatchingCard(c100281064.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function c100281064.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100281064.filter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c100281064.filter2,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(100281064,1),aux.Stringid(100281064,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(100281064,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(100281064,2))+1
	end
	if op==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	else
		e:SetCategory(0)
	end
	e:SetLabel(op)
end
function c100281064.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100281064.filter1),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c100281064.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g:GetFirst())
		end
	end
end
function c100281064.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_SZONE) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousSequence()<5
end
function c100281064.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c100281064.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end


