--Beetrooper Scale Bomber
--coded by Lyris
function c101105086.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101105086,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101105086)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c101105086.spcon)
	e1:SetTarget(c101105086.sptg)
	e1:SetOperation(c101105086.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--destroy chain
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,39041551)
	e3:SetCondition(c101105086.condition)
	e3:SetCost(c101105086.cost)
	e3:SetTarget(c101105086.target)
	e3:SetOperation(c101105086.operation)
	c:RegisterEffect(e3)
end
function c101105086.filter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_INSECT) and c:IsControler(tp)
end
function c101105086.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101105086.filter,1,nil,tp)
end
function c101105086.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101105086.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101105086.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and re:IsActiveType(TYPE_MONSTER)
end
function c101105086.cfilter(c,tp)
	return c:IsRace(RACE_INSECT) and (c:IsControler(tp) or c:IsFaceup())
end
function c101105086.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101105086.cfilter,1,re:GetHandler(),tp) end
	local g=Duel.SelectReleaseGroup(tp,c101105086.cfilter,1,1,re:GetHandler(),tp)
	Duel.Release(g,REASON_COST)
end
function c101105086.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function c101105086.operation(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
