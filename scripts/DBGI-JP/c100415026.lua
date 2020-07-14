--竜輝巧-エルγ

--Scripted by mallu11
function c100415026.initial_effect(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c100415026.splimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100415026,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,100415026)
	e2:SetCost(c100415026.spcost)
	e2:SetTarget(c100415026.sptg)
	e2:SetOperation(c100415026.spop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(100415026,ACTIVITY_SPSUMMON,c100415026.counterfilter)
end
function c100415026.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x250)
end
function c100415026.counterfilter(c)
	return not c:IsSummonableCard()
end
function c100415026.costfilter(c,tp)
	return (c:IsSetCard(0x250) or c:IsType(TYPE_RITUAL)) and c:IsType(TYPE_MONSTER) and Duel.GetMZoneCount(tp,c)>0
end
function c100415026.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return Duel.GetCustomActivityCount(100415026,tp,ACTIVITY_SPSUMMON)==0 and Duel.CheckReleaseGroupEx(tp,c100415026.costfilter,1,e:GetHandler(),tp) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c100415026.splimit2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroupEx(tp,c100415026.costfilter,1,1,e:GetHandler(),tp)
	Duel.Release(g,REASON_COST)
end 
function c100415026.splimit2(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsSummonableCard()
end
function c100415026.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=e:GetLabel()==100 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then
		e:SetLabel(0)
		return res and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
	end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100415026.rbfilter(c,e,tp)
	return c:IsSetCard(0x250) and c:IsAttack(2000) and not c:IsCode(100415026) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100415026.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c100415026.rbfilter),tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(100415026,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100415026.rbfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
