--War Lock Fortia
--Scripted by Kohana Sonogami
function c101103093.initial_effect(c)
	--tohand & atkchange
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101103093,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_BATTLED)
	e1:SetCountLimit(1,101103093)
	e1:SetTarget(c101103093.thtg)
	e1:SetOperation(c101103093.thop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101103093,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,101103093+100)
	e2:SetCondition(c101103093.spcon)
	e2:SetTarget(c101103093.sptg)
	e2:SetOperation(c101103093.spop)
	c:RegisterEffect(e2)
end
function c101103093.thfilter(c)
	return c:IsSetCard(0x263) and not c:IsCode(101103093) and c:IsAbleToHand()
end
function c101103093.check(c,tp)
	return c and c:IsControler(tp) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_WARRIOR)
end
function c101103093.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetAttackTarget()~=nil
		and (c101103093.check(Duel.GetAttacker(),tp) or c101103093.check(Duel.GetAttackTarget(),tp))
		and Duel.IsExistingMatchingCard(c101103093.thfilter,tp,LOCATION_DECK,0,1,nil) end
	if c101103093.check(Duel.GetAttacker(),tp) then
		Duel.SetTargetCard(Duel.GetAttackTarget())
	else
		Duel.SetTargetCard(Duel.GetAttacker())
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101103093.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x263)
end
function c101103093.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101103093.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c101103093.atkfilter,tp,LOCATION_MZONE,0,1,nil) then
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
		local sg=Duel.GetMatchingGroup(c101103093.atkfilter,tp,LOCATION_MZONE,0,nil)
		local tc=sg:GetFirst() 
		for tc in aux.Next(sg) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(200)
			tc:RegisterEffect(e1)
		end
	end
end
function c101103093.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsPreviousLocation(LOCATION_MZONE) and c:IsReason(REASON_EFFECT)
end
function c101103093.spfilter(c,e,tp)
	return c:IsLevelAbove(5) and c:IsSetCard(0x263) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101103093.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101103093.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c101103093.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101103093.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
