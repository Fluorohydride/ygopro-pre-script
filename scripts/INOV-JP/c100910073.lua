--完全燃焼
--Burn Out
--Script by nekrozar
function c100910073.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100910073+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c100910073.cost)
	e1:SetTarget(c100910073.target)
	e1:SetOperation(c100910073.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100910073,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c100910073.spcon)
	e2:SetCost(c100910073.spcost)
	e2:SetTarget(c100910073.sptg)
	e2:SetOperation(c100910073.spop)
	c:RegisterEffect(e2)
end
function c100910073.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xeb) and c:IsAbleToRemoveAsCost()
end
function c100910073.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100910073.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c100910073.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c100910073.spfilter1(c,e,tp)
	return c:IsSetCard(0xeb) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c100910073.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c100910073.spfilter2(c,e,tp,code)
	return c:IsSetCard(0xeb) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100910073.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100910073.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c100910073.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c100910073.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g1:GetCount()<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,c100910073.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,g1:GetFirst():GetCode())
		g1:Merge(g2)
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100910073.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
		and aux.exccon(e,tp,eg,ep,ev,re,r,rp)
end
function c100910073.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c100910073.spfilter3(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_DUAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100910073.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c100910073.spfilter3(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c100910073.spfilter3,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c100910073.spfilter3,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100910073.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		tc:EnableDualState()
	end
end
