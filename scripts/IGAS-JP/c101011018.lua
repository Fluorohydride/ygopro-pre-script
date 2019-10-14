--クロノダイバー・タイムレコーダー

--Scripted by mallu11
function c101011018.initial_effect(c)
	--battle damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101011018,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_ATTACK)
	e1:SetCountLimit(1,101011018)
	e1:SetCondition(c101011018.bdcon)
	e1:SetCost(c101011018.bdcost)
	e1:SetOperation(c101011018.bdop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101011018,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101011118)
	e2:SetCondition(c101011018.spcon)
	e2:SetTarget(c101011018.sptg)
	e2:SetOperation(c101011018.spop)
	c:RegisterEffect(e2)
end
function c101011018.bdcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) and Duel.GetTurnPlayer()==1-tp
end
function c101011018.bdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c101011018.bdop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetCondition(c101011018.damcon)
	e1:SetOperation(c101011018.damop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101011018.damcon(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	return ep==tp and ac and ac:IsControler(1-tp) and Duel.GetFlagEffect(tp,101011018)==0
end
function c101011018.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,0,false)
	Duel.ChangeBattleDamage(1-ep,ev,false)
	Duel.RegisterFlagEffect(tp,101011018,RESET_PHASE+PHASE_END,0,1)
end
function c101011018.cfilter(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and c:IsReason(REASON_EFFECT) and bit.band(c:GetPreviousTypeOnField(),TYPE_XYZ)~=0 and c:IsPreviousLocation(LOCATION_MZONE)
end
function c101011018.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101011018.cfilter,1,nil,tp)
end
function c101011018.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101011018.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		c:RegisterEffect(e1,true)
	end
end
