--クリバー
--Script by REIKAI
function c100278001.initial_effect(c)
	aux.AddCodeList(c,40640057)
	--Destroyed
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100278001,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCountLimit(1,100278001)
	e1:SetTarget(c100278001.sptg)
	e1:SetOperation(c100278001.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c100278001.spcon)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100278001,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c100278001.spcost2)
	e3:SetTarget(c100278001.sptg2)
	e3:SetOperation(c100278001.spop2)
	c:RegisterEffect(e3)
end
c100278001.spchecks=aux.CreateChecks(Card.IsCode,{100278002,100278003,100278004,40640057})
function c100278001.spfilter(c,e,tp)
	return c:IsDefense(200) and c:IsAttack(300) and not c:IsCode(100278001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100278001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100278001.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c100278001.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100278001.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100278001.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousControler(tp) and c:IsPreviousSetCard(0xa4)
end
function c100278001.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100278001.cfilter,1,nil,tp)
end
function c100278001.rlfilter(c,tp)
	return c:IsCode(100278002,100278003,100278004,40640057) and (c:IsControler(tp) or c:IsFaceup())
end
function c100278001.rlcheck(sg,c,tp)
	local g=sg:Clone()
	g:AddCard(c)
	return Duel.GetMZoneCount(tp,g)>0 and Duel.CheckReleaseGroupEx(tp,aux.IsInGroup,#g,nil,g)
end
function c100278001.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetReleaseGroup(tp,true):Filter(c100278001.rlfilter,c,tp)
	if chk==0 then return c:IsReleasable() and g:CheckSubGroupEach(c100278001.spchecks,c100278001.rlcheck,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g:SelectSubGroupEach(tp,c100278001.spchecks,false,c100278001.rlcheck,c,tp)
	aux.UseExtraReleaseCount(rg,tp)
	rg:AddCard(c)
	Duel.Release(rg,REASON_COST)
end
function c100278001.spfilter2(c,e,tp)
	return c:IsCode(100278005) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100278001.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100278001.spfilter2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
end
function c100278001.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100278001.spfilter2),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
