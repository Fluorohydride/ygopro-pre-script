--双天の獅使－阿吽
--Script by 奥克斯
function c101112038.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0x14f),2,true)
	--effect gain
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c101112038.regcon)
	e0:SetOperation(c101112038.regop)
	c:RegisterEffect(e0)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c101112038.spcon)
	e3:SetTarget(c101112038.sptg)
	e3:SetOperation(c101112038.spop)
	c:RegisterEffect(e3)
end
function c101112038.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c101112038.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	if #g==0 then return end
	if g:IsExists(Card.IsType,1,nil,TYPE_EFFECT) then
		c:RegisterFlagEffect(85360035,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1)
	end
	local chk1=0
	local chk2=0
	if g:IsExists(Card.IsOriginalCodeRule,1,nil,33026283) then
		chk1=1
		c:RegisterFlagEffect(101112038,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(101112038,0))
	end
	if g:IsExists(Card.IsOriginalCodeRule,1,nil,284224) then
		chk2=1
		c:RegisterFlagEffect(101112038,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(101112038,1))
	end
	--atk down
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetCondition(c101112038.atkcon)
	e1:SetTarget(c101112038.atktg)
	e1:SetValue(3000)
	e1:SetLabel(chk1)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112038,2))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetCountLimit(1)
	e2:SetCondition(c101112038.rmcon)
	e2:SetTarget(c101112038.rmtg)
	e2:SetOperation(c101112038.rmop)
	e2:SetLabel(chk2)
	c:RegisterEffect(e2)
end
function c101112038.atkcon(e)
	if e:GetLabel()~=1 then return false end
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetBattleMonster(tp)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and a and a:IsSetCard(0x14f)
end
function c101112038.atktg(e,c)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetBattleMonster(tp)
	return c==a
end
function c101112038.rmcon(e)
	if e:GetLabel()~=1 then return false end
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function c101112038.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c101112038.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c101112038.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_FUSION)
end
function c101112038.spfilter(c,e,tp)
	return c:IsCode(85360035,11759079) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101112038.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c101112038.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	local spchk=Duel.IsPlayerAffectedByEffect(tp,59822133)
	if spchk then return false end
	if chk==0 then return ft>1 and g:CheckSubGroup(aux.dncheck,2,2) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c101112038.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c101112038.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	local spchk=Duel.IsPlayerAffectedByEffect(tp,59822133)
	if spchk then return false end
	if ft<1 or not g:CheckSubGroup(aux.dncheck,2,2) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	if #sg~=2 then return false end
	local tc=sg:GetFirst()
	for tc in aux.Next(sg) do
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e2:SetValue(1)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			tc:RegisterFlagEffect(101112038,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(101112038,3))
		end
	end
	Duel.SpecialSummonComplete()
end