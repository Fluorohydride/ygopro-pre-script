--刹帝利拉族基地
function c101110060.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--decrease tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101110060,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetCountLimit(1)
	e2:SetCondition(c101110060.ntcon)
	e2:SetTarget(c101110060.nttg)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101110060,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,101110060)
	e3:SetTarget(c101110060.sptg)
	e3:SetOperation(c101110060.spop)
	c:RegisterEffect(e3)
	--remove when chaining
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101110060,2))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,101110060+100)
	e4:SetCondition(c101110060.rmcon)
	e4:SetTarget(c101110060.rmtg)
	e4:SetOperation(c101110060.rmop)
	c:RegisterEffect(e4)
end
function c101110060.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c101110060.nttg(e,c)
	return c:IsLevel(7)
end
function c101110060.spfilter(c,e,tp)
	return c:IsSetCard(0x288) and not c:IsType(TYPE_XYZ) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101110060.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101110060.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c101110060.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101110060.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101110060.rmcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x288)
end
function c101110060.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_SPELL)
		and Duel.IsExistingMatchingCard(c101110060.rmcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101110060.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToRemove(tp,POS_FACEDOWN) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,3,nil,tp,POS_FACEDOWN) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,3,3,nil,tp,POS_FACEDOWN)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
end
function c101110060.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #tg>0 then
		Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
	end
end