--毒蛇の怨念
--
--Script by REIKAI
function c100286008.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--cannot attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c100286008.e1tg)
	c:RegisterEffect(e1)
	local e1_1=e1:Clone()
	e1_1:SetCode(EFFECT_CANNOT_TRIGGER)
	c:RegisterEffect(e1_1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetCondition(c100286008.regcon)
	e2:SetOperation(c100286008.regop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c100286008.regcon2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100286008,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_CUSTOM+100286008)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,100286008)
	e4:SetTarget(c100286008.sptg)
	e4:SetOperation(c100286008.spop)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(100286008,2))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCountLimit(1,100286108)
	e5:SetCondition(c100286008.tgcon)
	e5:SetTarget(c100286008.tgtg)
	e5:SetOperation(c100286008.tgop)
	c:RegisterEffect(e5)
end
function c100286008.e1tg(e,c)
	return not c:IsRace(RACE_REPTILE)
end
function c100286008.cfilter(c,tp,zone)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsRace(RACE_REPTILE) and c:IsPreviousPosition(POS_FACEUP)
end
function c100286008.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100286008.cfilter,1,nil,tp,e:GetHandler():GetLinkedZone())
end
function c100286008.cfilter2(c,tp,zone)
	return not c:IsReason(REASON_BATTLE) and c100286008.cfilter(c,tp,zone)
end
function c100286008.regcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100286008.cfilter2,1,nil,tp,e:GetHandler():GetLinkedZone())
end
function c100286008.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+100286008,e,0,tp,0,0)
end
function c100286008.spfilter(c,e,tp)
	return c:IsRace(RACE_REPTILE) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100286008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100286008.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c100286008.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100286008.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100286008.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_SZONE)
end
function c100286008.filter(c,e,tp)
	return c:IsRace(RACE_REPTILE) and c:IsFaceup()
end
function c100286008.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100286008.filter,tp,LOCATION_REMOVED,0,1,nil) end
end
function c100286008.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100286008.filter,tp,LOCATION_REMOVED,0,nil)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
end