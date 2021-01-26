--War Rock Bashileos
--Scripted by Kohana Sonogami
function c101103097.initial_effect(c)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101103097,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101103097)
	e1:SetCondition(c101103097.dracon)
	e1:SetOperation(c101103097.draop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101103097,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101103097+100)
	e2:SetCondition(c101103097.spcon)
	e2:SetTarget(c101103097.sptg)
	e2:SetOperation(c101103097.spop)
	c:RegisterEffect(e2)
end
function c101103097.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_EARTH) and c:GetBattledGroupCount()>0
end
function c101103097.dracon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101103097.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c101103097.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x263)
end
function c101103097.draop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local g=Duel.GetMatchingGroup(c101103097.atkfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst() 
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,Duel.GetTurnPlayer()==tp and 2 or 1)
		e1:SetValue(200)
		tc:RegisterEffect(e1)
	end
end
function c101103097.spfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsSetCard(0x253) and c:IsType(TYPE_MONSTER)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_BATTLE)
end
function c101103097.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101103097.spfilter,1,nil,tp)
end
function c101103097.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101103097.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
