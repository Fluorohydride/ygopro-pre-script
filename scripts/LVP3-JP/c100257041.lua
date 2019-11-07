--クロスローズ・ドラゴン

--Scripted by mallu11
function c100257041.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,c100257041.lcheck)
	--spsummon1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100257041,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100257041)
	e1:SetCondition(c100257041.spcon1)
	e1:SetCost(c100257041.spcost1)
	e1:SetTarget(c100257041.sptg1)
	e1:SetOperation(c100257041.spop1)
	c:RegisterEffect(e1)
	--spsummon2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100257041,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100257141)
	e2:SetCondition(c100257041.spcon2)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c100257041.sptg2)
	e2:SetOperation(c100257041.spop2)
	c:RegisterEffect(e2)
end
function c100257041.lcheck(g)
	return g:GetClassCount(Card.GetLinkRace)==g:GetCount()
end
function c100257041.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c100257041.rfilter(c,e,tp,mc)
	return c:IsRace(RACE_PLANT) and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c100257041.spfilter1(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and (c:IsSetCard(0x123) or c:IsRace(RACE_PLANT)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c100257041.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c100257041.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return c:IsReleasable() and Duel.CheckReleaseGroup(tp,c100257041.rfilter,1,c,e,tp,c)
			and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
			and Duel.IsExistingMatchingCard(c100257041.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c100257041.rfilter,1,1,c,e,tp,c)
	g:AddCard(c)
	Duel.Release(g,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100257041.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100257041.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)~=0 then
		tc:CompleteProcedure()
	end
end
function c100257041.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp and c:IsReason(REASON_EFFECT)
end
function c100257041.spfilter2(c,e,tp)
	return c:IsSetCard(0x1123) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100257041.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100257041.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c100257041.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100257041.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c100257041.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100257041.spfilter2),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
