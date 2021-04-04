--絆醒師セームベル
--
--scripted by FaultZone
function c101105030.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101105030,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,101105030)
	e1:SetTarget(c101105030.destg)
	e1:SetOperation(c101105030.desop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101105030,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101105030+100)
	e2:SetCondition(c101105030.spcon)
	e2:SetTarget(c101105030.sptg)
	e2:SetOperation(c101105030.spop)
	c:RegisterEffect(e2)
end
function c101105030.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	local tc=(g-c):GetFirst()
	if chk==0 then return tc and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:GetOriginalLevel()==tc:GetOriginalLevel() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,LOCATION_PZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,LOCATION_PZONE)
end
function c101105030.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	local tc=(g-c):GetFirst()
	if not e:GetHandler():IsRelateToEffect(e) or not tc or Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	if Duel.Destroy(tc,REASON_EFFECT)>0 then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
end
function c101105030.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not eg:IsContains(c) and eg:IsExists(Card.IsControler,1,c,tp) then return true end
end
function c101105030.spfilter(c,e,tp,lvl)
	return c:IsLevel(lvl) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101105030.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101105030.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,e:GetHandler():GetLevel()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND)
end
function c101105030.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101105030.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,c:GetLevel())
	if #g>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
end
