--Giant Beetrooper Invincible Atlas
--
--scripted by RayeHikawa & mercury233
function c101105089.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_INSECT),2)
	--cannot target & indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetCondition(c101105089.condition)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	--splimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c101105089.splimit)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101105089,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,101105089)
	e4:SetCost(c101105089.spcost)
	e4:SetTarget(c101105089.sptg)
	e4:SetOperation(c101105089.spop)
	c:RegisterEffect(e4)
	--atk up
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(101105089,1))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,101105089)
	e5:SetCost(c101105089.atkcost)
	e5:SetTarget(c101105089.atktg)
	e5:SetOperation(c101105089.atkop)
	c:RegisterEffect(e5)
end
function c101105089.condition(e)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK) and c:IsAttackBelow(3000)
end
function c101105089.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_INSECT)
end
function c101105089.costfilter(c,tp)
	return c:IsRace(RACE_INSECT) and (c:IsControler(tp) or c:IsFaceup())
end
function c101105089.spcostfilter(c,tp)
	return c101105089.costfilter(c,tp) and Duel.GetMZoneCount(tp,c)>0
end
function c101105089.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101105089.spcostfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c101105089.spcostfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c101105089.spfilter(c,e,tp)
	return c:IsSetCard(0x270) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101105089.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101105089.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101105089.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c101105089.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c101105089.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101105089.costfilter,1,e:GetHandler(),tp) end
	local g=Duel.SelectReleaseGroup(tp,c101105089.costfilter,1,1,e:GetHandler(),tp)
	Duel.Release(g,REASON_COST)
end
function c101105089.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c101105089.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(2000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
