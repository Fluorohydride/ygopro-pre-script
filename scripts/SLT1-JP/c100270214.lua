--圣蔓之守护者
function c100270214.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c100270214.mfilter,1,1)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100270214,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c100270214.descon)
	e1:SetTarget(c100270214.destg)
	e1:SetOperation(c100270214.desop)
	c:RegisterEffect(e1)
	--half damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100270214,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c100270214.dmcon)
	e2:SetOperation(c100270214.dmop)
	c:RegisterEffect(e2)
	--skip
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetCondition(c100270214.con)
	e3:SetOperation(c100270214.op)
	c:RegisterEffect(e3)
end
function c100270214.mfilter(c)
	return c:IsLinkType(TYPE_NORMAL) and c:IsLinkRace(RACE_PLANT)
end
function c100270214.cfilter(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and c:IsReason(REASON_EFFECT)
		and bit.band(c:GetPreviousTypeOnField(),TYPE_LINK)~=0 and c:IsPreviousSetCard(0x256) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c100270214.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100270214.cfilter,1,nil,tp)
end
function c100270214.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c100270214.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c100270214.filter(c,ec)
	return c:IsFaceup() and c:IsSetCard(0x256) and c:IsType(TYPE_LINK) and c:GetLinkedGroup():IsContains(ec)
end
function c100270214.dmcon(e,tp,eg,ep,ev,re,r,rp)
	local a,d,c=Duel.GetAttacker(),Duel.GetAttackTarget(),e:GetHandler()
	local g=Duel.GetMatchingGroup(c100270214.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	return d and (a==c or b==c) and a:GetControler()~=d:GetControler() and #g>0
end
function c100270214.dmop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(HALF_DAMAGE)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c100270214.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
function c100270214.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
end