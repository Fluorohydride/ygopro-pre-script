--ランタン・シャーク
--not fully implemented
--Scripted by mallu11
function c101012018.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101012018,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101012018)
	e1:SetTarget(c101012018.sptg)
	e1:SetOperation(c101012018.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--xyzlv
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_XYZ_LEVEL)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c101012018.xyzlv)
	c:RegisterEffect(e3)
	--
	if not c101012018.global_check then
		c101012018.global_check=true
		Duel.RegisterFlagEffect(0,101012018,0,0,1,5)
		Duel.RegisterFlagEffect(1,101012018,0,0,1,5)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_FREE_CHAIN)
		ge1:SetCountLimit(10)
		ge1:SetOperation(c101012018.xyzlvop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		Duel.RegisterEffect(ge2,1)
		c101012018.xyzlvop(ge1,0)
		c101012018.xyzlvop(ge2,1)
	end
end
function c101012018.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsLevelAbove(3) and c:IsLevelBelow(5) and not c:IsCode(101012018) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c101012018.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c101012018.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c101012018.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c101012018.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c101012018.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c101012018.splimit(e,c)
	return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)
end
function c101012018.xyzlv(e,c,rc)
	if rc:IsAttribute(ATTRIBUTE_WATER) then
		return c:GetLevel()+0x10000*Duel.GetFlagEffectLabel(tp,101012018)
	else
		return c:GetLevel()
	end
end
function c101012018.xyzlvop(e,tp,eg,ep,ev,re,r,rp)
	local lv=8-Duel.GetFlagEffectLabel(tp,101012018)
	Duel.SetFlagEffectLabel(tp,101012018,lv)
	local olde=e:GetLabelObject()
	if olde then olde:Reset() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(101012018,lv))
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	e:SetLabelObject(e1)
end
