--不知火の隠者
--Shiranui Sage
--Script by mercury233
function c100909103.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100909103,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,100909103)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c100909103.cost)
	e1:SetTarget(c100909103.target)
	e1:SetOperation(c100909103.operation)
	c:RegisterEffect(e1)
	--special summon(remove)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100909103,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,100909203)
	e2:SetTarget(c100909103.sptg)
	e2:SetOperation(c100909103.spop)
	c:RegisterEffect(e2)
end
function c100909103.costfilter(c)
	return c:IsRace(RACE_ZOMBIE)
end
function c100909103.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c100909103.costfilter,1,nil) end
	local sg=Duel.SelectReleaseGroup(tp,c100909103.costfilter,1,1,nil)
	Duel.Release(sg,REASON_COST)
end
function c100909103.spfilter1(c,e,tp)
	return c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_TUNER) and c:GetDefence()==0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100909103.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c100909103.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c100909103.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100909103.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)	end
end
function c100909103.spfilter2(c,e,tp)
	return c:IsSetCard(0xd9) and not c:IsCode(100909103) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100909103.cfilter(c)
	return c:IsFaceup() and c:IsCode(40005099)
end
function c100909103.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c100909103.spfilter2(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c100909103.spfilter2,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	local max=1
	if Duel.IsExistingMatchingCard(c100909103.cfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 then
		max=2
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c100909103.spfilter2,tp,LOCATION_REMOVED,0,1,max,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100909103.spop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=tg:Filter(Card.IsRelateToEffect,nil,e)
	local ct=g:GetCount()
	if ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	and (ct==1 or not (Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<2)) then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
