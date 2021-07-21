--D－HERO ディナイアルガイ
--
--Script by mercury233
function c101106018.initial_effect(c)
	--to deck top
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101106018,0))
	e1:SetCategory(CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101106018)
	e1:SetTarget(c101106018.tdtg)
	e1:SetOperation(c101106018.tdop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--revive
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101106018,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,101106018+100+EFFECT_COUNT_CODE_DUEL)
	e3:SetCondition(c101106018.spcon)
	e3:SetTarget(c101106018.sptg)
	e3:SetOperation(c101106018.spop)
	c:RegisterEffect(e3)
end
function c101106018.tdfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xc008)
		and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
		and (not c:IsLocation(LOCATION_DECK) or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1)
end
function c101106018.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c101106018.tdfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp)
	end
end
function c101106018.tdop(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_GRAVE+LOCATION_REMOVED
	if not Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c101106018.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp)
		or Duel.IsExistingMatchingCard(c101106018.tdfilter,tp,LOCATION_DECK,0,1,nil,tp)
			and Duel.SelectYesNo(tp,aux.Stringid(101106018,3)) then
		loc=loc+LOCATION_DECK
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101106018,2))
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101106018.tdfilter),tp,loc,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		if not tc:IsLocation(LOCATION_DECK) then
			Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
		end
		if loc&LOCATION_DECK>0 then
			Duel.ShuffleDeck(tp)
		end
		if tc:IsLocation(LOCATION_DECK) then
			Duel.MoveSequence(tc,0)
			Duel.ConfirmDecktop(tp,1)
		end
	end
end
function c101106018.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xc008) and not c:IsCode(101106018)
end
function c101106018.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101106018.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function c101106018.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101106018.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
