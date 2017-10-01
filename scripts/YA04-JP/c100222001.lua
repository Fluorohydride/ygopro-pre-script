--白闘気双頭神龍
--White Aura Biphamet
function c100222001.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100222001,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c100222001.tkcon)
	e1:SetTarget(c100222001.tktg)
	e1:SetOperation(c100222001.tkop)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100222001,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_BATTLE_START+TIMING_END_PHASE)
	e2:SetCondition(c100222001.tkcon2)
	e2:SetTarget(c100222001.tktg)
	e2:SetOperation(c100222001.tkop2)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100222001,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c100222001.spcon)
	e3:SetTarget(c100222001.sptg)
	e3:SetOperation(c100222001.spop)
	c:RegisterEffect(e3)
end
function c100222001.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c100222001.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsPlayerCanSpecialSummonMonster(tp,100222001+100,0,0x4011,3300,3000,10,RACE_FISH,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c100222001.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,100222001+100,0,0x4011,3300,3000,10,RACE_FISH,ATTRIBUTE_WATER) then
		local token=Duel.CreateToken(tp,100222001+100)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c100222001.tkcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_TOKEN)
end
function c100222001.tkop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,100222001+100,0,0x4011,3300,3000,10,RACE_FISH,ATTRIBUTE_WATER) then
		local token=Duel.CreateToken(tp,100222001+100)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100222001.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and rp~=tp and c:IsReason(REASON_EFFECT)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c100222001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,100222001+100) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100222001.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
