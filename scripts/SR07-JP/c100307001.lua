--死霊王 ドーハスーラ
--Drochshúile the Spirit King
--Script by dest
function c100307001.initial_effect(c)
	--negate / banish
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100307001,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c100307001.disrmcon)
	e1:SetTarget(c100307001.disrmtg)
	e1:SetOperation(c100307001.disrmop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100307001,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1,100307001)
	e2:SetCondition(c100307001.spcon)
	e2:SetTarget(c100307001.sptg)
	e2:SetOperation(c100307001.spop)
	c:RegisterEffect(e2)
end
function c100307001.disrmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	local race=c:GetRace()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if loc==LOCATION_HAND then race=c:GetOriginalRace() end
	if loc==LOCATION_MZONE and not c:IsLocation(LOCATION_MZONE) then race=c:GetPreviousRaceOnField() end
	return race==RACE_ZOMBIE and not c:IsCode(100307001)
end
function c100307001.disrmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsChainDisablable(ev) and Duel.GetFlagEffect(tp,100307001)==0
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil)
		and Duel.GetFlagEffect(tp,100307001+100)==0
	if chk==0 then return b1 or b2 end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c100307001.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c100307001.disrmop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsChainDisablable(ev) and Duel.GetFlagEffect(tp,100307001)==0
	local b2=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c100307001.filter),tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil)
		and Duel.GetFlagEffect(tp,100307001+100)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(100307001,1),aux.Stringid(100307001,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(100307001,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(100307001,2))+1
	else return end
	if op==0 then
		Duel.NegateEffect(ev)
		Duel.RegisterFlagEffect(tp,100307001,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c100307001.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,100307001+100,RESET_PHASE+PHASE_END,0,1)
	end
end
function c100307001.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function c100307001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100307001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
