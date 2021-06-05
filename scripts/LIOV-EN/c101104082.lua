--Thron the Disciplined Angel
--scripted by XyleN
function c101104082.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101104082,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101104082)
	e1:SetCondition(c101104082.condition)
	e1:SetTarget(c101104082.target)
	e1:SetOperation(c101104082.operation)
	c:RegisterEffect(e1)
end
function c101104082.filter(c,tp)
	return c:GetOriginalAttribute()==ATTRIBUTE_EARTH and c:GetOriginalRace()==RACE_FAIRY
		and c:IsPreviousLocation(LOCATION_HAND+LOCATION_MZONE) and c:IsPreviousControler(tp)
end
function c101104082.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101104082.filter,1,nil,tp)
end
function c101104082.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101104082.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
