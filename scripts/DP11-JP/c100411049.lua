--月光小夜曲舞踊
--Lunalight Serenade Dance
--Logical Nonsense
--edited by Szefo09

function c100411049.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100411049,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--ATK gain and token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100411049,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c100411049.tkcon)
	e2:SetTarget(c100411049.tktg)
	e2:SetOperation(c100411049.tkop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e3)
	--Special summon from deck, quick effect
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100411049,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,100411049)
	e4:SetCost(aux.bfgcost)
	e4:SetCondition(c100411049.spcon)
	e4:SetTarget(c100411049.sptg)
	e4:SetOperation(c100411049.spop)
	c:RegisterEffect(e4)
end
	--If fusion monster(s) were fusion summoned to your field
function c100411049.cfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_FUSION)
end
	--If it ever happened
function c100411049.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100411049.cfilter,1,nil,tp)
end
	--Activation legality
function c100411049.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c100411049.cfilter(chkc,e,1-tp) end
	if chk==0 then return eg:IsExists(c100411049.cfilter,1,nil,e,1-tp) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,100411049+100,0xdf,0x4011,2000,2000,1,RACE_BEASTWARRIOR,ATTRIBUTE_DARK,POS_FACEUP,1-tp) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=eg:FilterSelect(tp,c100411049.cfilter,1,1,nil,e,1-tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
	--Performing the effect of ATK gain and token special summoned to opponent's field
function c100411049.tkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(c100411049.value)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,100411049+100,0xdf,0x4011,2000,2000,1,RACE_BEASTWARRIOR,ATTRIBUTE_DARK,POS_FACEUP,1-tp) then
		local token=Duel.CreateToken(tp,100411049+100)
		Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP)
	end
end

function c100411049.value(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)*500
end
	--Check if current phase is main phase
function c100411049.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tn=Duel.GetTurnPlayer()
	local ph=Duel.GetCurrentPhase()
	return tn==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
	--Check for "Lunalight" monster
function c100411049.spfilter(c,e,tp,zone)
	return c:IsSetCard(0xdf) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
	--Activation legality
function c100411049.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100411049.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) 
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
	--Performing the effect of sending a card from hand to GY, and then special summmoning 1 "Lunalight" monster from deck
function c100411049.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0
		and g:GetFirst():IsLocation(LOCATION_GRAVE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c100411049.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if zone~=0 and sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
