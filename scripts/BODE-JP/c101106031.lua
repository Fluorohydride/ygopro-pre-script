--陽竜果フォンリー
--
--scripted by KillerDJ
function c101106031.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101106031,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101106031)
	e1:SetCondition(c101106031.spcon)
	e1:SetTarget(c101106031.sptg)
	e1:SetOperation(c101106031.spop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetCountLimit(1)
	e2:SetTarget(c101106031.desreptg)
	c:RegisterEffect(e2)
end
function c101106031.spcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and re:IsActiveType(TYPE_MONSTER)
		and e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function c101106031.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101106031.checkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_PLANT)
end
function c101106031.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if e:GetHandler():IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c101106031.checkfilter,tp,LOCATION_MZONE,0,1,c)
		and Duel.SelectYesNo(tp,aux.Stringid(101106031,1)) then
			Duel.BreakEffect()
			local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
			Duel.HintSelection(g)
			local tc=g:GetFirst()
			if tc then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_ATTACK_FINAL)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(math.ceil(tc:GetAttack()/2))
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				e2:SetValue(math.ceil(tc:GetDefense()/2))
				tc:RegisterEffect(e2)
			end
	end
end
function c101106031.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_DECK,0,1,nil,RACE_PLANT) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsRace,tp,LOCATION_DECK,0,1,1,nil,RACE_PLANT)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end