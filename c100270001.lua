--竜血公ヴァンパイア
--Draculea Vampire
--LUA by Kohana Sonogami
--
function c100270001.initial_effect(c)
	--Special Summon up to 2 Zombie monsters
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,100270001)
	e1:SetTarget(c100270001.sptg1)
	e1:SetOperation(c100270001.spop1)
	c:RegisterEffect(e1)
	--Negate the activation with the same name
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100270001,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100270002)
	e2:SetCondition(c100270001.negcon)
	e2:SetTarget(c100270001.negtg)
	e2:SetOperation(c100270001.negop)
	c:RegisterEffect(e2)
	--Special Summon this card from your GY
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100270001,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,100270003+100)
	e3:SetCondition(c100270001.spcon2)
	e3:SetCost(c100270001.spcost2)
	e3:SetTarget(c100270001.sptg2)
	e3:SetOperation(c100270001.spop2)
	c:RegisterEffect(e3)
end
function c100270001.spfilter(c,e,tp)
	return c:IsRace(RACE_ZOMBIE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100270001.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c100270001.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c100270001.spfilter,tp,0,LOCATION_GRAVE,2,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c100270001.spfilter,tp,0,LOCATION_GRAVE,1,2,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100270001.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local tc=sg:GetFirst() 
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		tc=sg:GetNext()
	end
	Duel.SpecialSummonComplete()
end
function c100270001.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
		and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,re:GetHandler():GetCode())
end
function c100270001.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c100270001.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function c100270001.cfilter(c,tp)
	return c:IsSummonLocation(LOCATION_GRAVE) and c:IsPreviousControler(1-tp)
end
function c100270001.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100270001.cfilter,1,nil,tp)
end
function c100270001.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,2,nil) end
	local sg=Duel.SelectReleaseGroup(tp,nil,2,2,nil)
	Duel.Release(sg,REASON_COST)
end
function c100270001.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100270001.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
