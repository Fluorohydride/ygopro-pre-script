--機巧蛙一整盾多適貝久
--
--Script by XyleN5967
function c101105017.initial_effect(c)
	--to deck top
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101105017,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101105017)
	e1:SetTarget(c101105017.tdtg)
	e1:SetOperation(c101105017.tdop)
	c:RegisterEffect(e1)
	local e2=e1:Clone() 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--revive
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101105017,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,101105017+100)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c101105017.sptg)
	e3:SetOperation(c101105017.spop)
	c:RegisterEffect(e3)
end
function c101105017.tdfilter(c)
	return c:GetTextAttack()==c:GetTextDefense() and c:IsRace(RACE_MACHINE)
end
function c101105017.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101105017.tdfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 end
end
function c101105017.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101105017,2))
	local g=Duel.SelectMatchingCard(tp,c101105017.tdfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
	end
end
function c101105017.spfilter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:GetTextAttack()==c:GetTextDefense() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101105017.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101105017.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101105017.spfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101105017.spfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101105017.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRace(RACE_MACHINE) and tc:GetTextAttack()==tc:GetTextDefense() and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
