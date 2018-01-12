--妖海のアウトロール
--Outroll of the Haunted Sea
--Script by nekrozar
function c101004030.initial_effect(c)
	--change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101004030,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101004030)
	e1:SetCost(c101004030.cost)
	e1:SetTarget(c101004030.cgtg)
	e1:SetOperation(c101004030.cgop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101004030,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101004130)
	e3:SetCost(c101004030.cost)
	e3:SetTarget(c101004030.sptg)
	e3:SetOperation(c101004030.spop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(101004030,ACTIVITY_SPSUMMON,c101004030.counterfilter)
end
function c101004030.counterfilter(c)
	return c:IsRace(RACE_BEASTWARRIOR)
end
function c101004030.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(101004030,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101004030.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c101004030.splimit(e,c)
	return not c:IsRace(RACE_BEASTWARRIOR)
end
function c101004030.cgfilter(c,mc)
	return c:IsRace(RACE_BEASTWARRIOR) and c:GetLevel()>0 and not (c:GetLevel()==mc:GetLevel() and c:IsAttribute(mc:GetAttribute()))
end
function c101004030.cgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101004030.cgfilter(chkc,c) end
	if chk==0 then return Duel.IsExistingTarget(c101004030.cgfilter,tp,LOCATION_GRAVE,0,1,nil,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101004030.cgfilter,tp,LOCATION_GRAVE,0,1,1,nil,c)
end
function c101004030.cgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and c:IsFaceup() and c:IsRelateToEffect(e) then
		local lv=tc:GetLevel()
		local att=tc:GetAttribute()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetValue(att)
		c:RegisterEffect(e2)
	end
end
function c101004030.spfilter(c,e,tp,mc)
	return c:IsLevel(mc:GetLevel()) and c:IsRace(mc:GetRace()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101004030.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101004030.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c101004030.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101004030.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
