--マジシャンズ・ローブ
--Magician's Robe
--Script by dest
function c100909018.initial_effect(c)
	--spsummon (DM)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100909018,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,100909018)
	e1:SetCondition(c100909018.condition1)
	e1:SetCost(c100909018.cost)
	e1:SetTarget(c100909018.target1)
	e1:SetOperation(c100909018.operation1)
	c:RegisterEffect(e1)
	--spsummon (self)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100909018,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,100909118)
	e2:SetCondition(c100909018.condition2)
	e2:SetTarget(c100909018.target2)
	e2:SetOperation(c100909018.operation2)
	c:RegisterEffect(e2)
end
function c100909018.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c100909018.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
end
function c100909018.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100909018.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c100909018.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c100909018.filter(c,e,tp)
	return c:IsCode(46986414) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100909018.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100909018.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c100909018.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100909018.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100909018.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and ep==tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c100909018.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c100909018.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
