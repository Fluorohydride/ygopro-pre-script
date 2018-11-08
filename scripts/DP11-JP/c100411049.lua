--月光小夜曲舞踊

--Script by nekrozar
function c100411049.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100411049,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100411049,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetTarget(c100411049.tktg)
	e2:SetOperation(c100411049.tkop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100411049,2))
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,100411049)
	e4:SetCondition(c100411049.spcon)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c100411049.sptg)
	e4:SetOperation(c100411049.spop)
	c:RegisterEffect(e4)
end
function c100411049.atkfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsSummonType(SUMMON_TYPE_FUSION) and c:IsControler(tp) and c:IsCanBeEffectTarget(e)
end
function c100411049.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c100411049.atkfilter(chkc,e,tp) end
	if chk==0 then return eg:IsExists(c100411049.atkfilter,1,nil,e,tp)
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,100411149,0xdf,0x4011,0,0,1,RACE_BEASTWARRIOR,ATTRIBUTE_DARK,POS_FACEUP,1-tp) end
	if eg:GetCount()==1 then
		Duel.SetTargetCard(eg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=eg:FilterSelect(tp,c100411049.atkfilter,1,1,nil,e,tp)
		Duel.SetTargetCard(g)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end
function c100411049.tkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,100411149,0xdf,0x4011,0,0,1,RACE_BEASTWARRIOR,ATTRIBUTE_DARK,POS_FACEUP,1-tp) then
		local token=Duel.CreateToken(tp,100411149)
		Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP)
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function c100411049.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c100411049.spfilter(c,e,tp)
	return c:IsSetCard(0xdf) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100411049.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(c100411049.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c100411049.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c100411049.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
