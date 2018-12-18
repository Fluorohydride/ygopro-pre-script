--星遺物の守護竜メロダーク
--
--Script by mercury233
function c101008018.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101008018)
	e1:SetCost(c101008018.spcost)
	e1:SetTarget(c101008018.sptg)
	e1:SetOperation(c101008018.spop)
	c:RegisterEffect(e1)
	--decrease atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c101008018.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101008018,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,101008018+100)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c101008018.thcon)
	e4:SetTarget(c101008018.thtg)
	e4:SetOperation(c101008018.thop)
	c:RegisterEffect(e4)
end
function c101008018.cfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsAbleToRemoveAsCost()
end
function c101008018.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101008018.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101008018.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101008018.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101008018.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c101008018.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function c101008018.atkval(e,c)
	return Duel.GetMatchingGroupCount(c101008018.atkfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)*-500
end
function c101008018.thcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c101008018.thfilter(c,ec)
	return c:IsLevel(9) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
		and not c:IsRace(ec:GetRace()) and not c:IsAttribute(ec:GetAttribute())
end
function c101008018.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101008018.thfilter,tp,LOCATION_GRAVE,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
end
function c101008018.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101008018.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
