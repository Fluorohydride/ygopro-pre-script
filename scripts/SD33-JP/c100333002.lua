--ガベージコレクター
--Garbage Collector
--Scripted by Eerie Code
function c100333002.initial_effect(c)
	--bounce and summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100333002,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100333002)
	e1:SetTarget(c100333002.target)
	e1:SetOperation(c100333002.operation)
	c:RegisterEffect(e1)
end
function c100333002.thfilter(c,e,tp,ft)
	return c:IsFaceup() and c:IsRace(RACE_CYBERSE)
		and (ft>0 or c:GetSequence()>=5)
		and Duel.IsExistingMatchingCard(c100333002.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c100333002.spfilter(c,e,tp,dc)
	return c:IsRace(RACE_CYBERSE) and c:IsLevel(dc:GetLevel())
		and not c:IsCode(dc:GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100333002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c100333002.thfilter(chkc,e,tp,ft) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c100333002.thfilter,tp,LOCATION_MZONE,0,1,c,e,tp,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c100333002.thfilter,tp,LOCATION_MZONE,0,1,1,c,e,tp,ft)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c100333002.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c100333002.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc)
		if g:GetCount()~=0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
