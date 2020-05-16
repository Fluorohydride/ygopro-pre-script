--機皇兵廠オブリガード
function c100424019.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100424019,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100424019)
	e1:SetTarget(c100424019.sptg)
	e1:SetOperation(c100424019.spop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100424019,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,100424119)
	e2:SetTarget(c100424019.dregtg)
	e2:SetOperation(c100424019.dregop)
	c:RegisterEffect(e2)
end
c100424019.listed_names={100424019}
c100424019.listed_series={0x13,0x6013}
function c100424019.spfilter(c,e,tp)
	return c:IsSetCard(0x6013) and c:IsType(TYPE_MONSTER) and not c:IsCode(100424019) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c100424019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if e:GetHandler():GetSequence()<5 then ft=ft+1 end
		return ft>0 and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) and Duel.IsExistingMatchingCard(c100424019.spfilter,tp,LOCATION_DECK,0,2,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,tp,LOCATION_MZONE)
end
function c100424019.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--Special Summon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c100424019.splimit)
	Duel.RegisterEffect(e1,tp)
	aux.RegisterClientHint(e:GetHandler(),nil,tp,1,0,aux.Stringid(100424019,2),nil)
	--perform special summon
	if Duel.Destroy(c,REASON_EFFECT)~=0 then
		if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
		local g=Duel.SelectMatchingCard(tp,c100424019.spfilter,tp,LOCATION_DECK,0,2,2,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end
function c100424019.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_MACHINE)
end
function c100424019.dregtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c100424019.dregop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(c100424019.damtg)
	e1:SetOperation(c100424019.damop)
	Duel.RegisterEffect(e1,tp)
end
function c100424019.damtg(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsSetCard,0x13),tp,LOCATION_MZONE,0,1,nil)
end
function c100424019.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,100424019)
	local dam=Duel.GetMatchingGroupCount(aux.FilterFaceupFunction(Card.IsSetCard,0x13),tp,LOCATION_MZONE,0,1,nil)
	Duel.Damage(1-tp,dam*100,REASON_EFFECT)
end
