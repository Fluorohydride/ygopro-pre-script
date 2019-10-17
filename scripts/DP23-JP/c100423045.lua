--EM天空の魔術師

--Scripted by mallu11
function c100423045.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100423045,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,100423045)
	e1:SetCondition(c100423045.spcon)
	e1:SetTarget(c100423045.sptg)
	e1:SetOperation(c100423045.spop)
	c:RegisterEffect(e1)
	--monster effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100423045,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100423145)
	e2:SetCondition(c100423045.mecon)
	e2:SetTarget(c100423045.metg)
	e2:SetOperation(c100423045.meop)
	c:RegisterEffect(e2)
	if not c100423045.global_check then
		c100423045.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetLabel(100423045)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge2:SetLabel(100423045)
		Duel.RegisterEffect(ge2,0)
	end
end
function c100423045.spfilter(c,tp,rp)
	return (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and rp==1-tp)) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:GetPreviousControler()==tp and c:GetSummonLocation()==LOCATION_EXTRA
		and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) and c:IsFaceup()
end
function c100423045.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==1 and eg:IsExists(c100423045.spfilter,1,nil,tp,rp)
end
function c100423045.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=eg:GetFirst()
	if chk==0 then return (ec:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
	or (ec:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp)>0) end
	Duel.SetTargetCard(ec)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,ec,1,0,0)
end
function c100423045.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=Duel.GetFirstTarget()
	if ec:IsRelateToEffect(e) and Duel.SpecialSummon(ec,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c100423045.mefilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
end
function c100423045.mefilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c100423045.thfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c100423045.mecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(100423045)>0
end
function c100423045.metg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100423045.mefilter1,tp,LOCATION_MZONE,0,1,e:GetHandler())
		or (Duel.IsExistingMatchingCard(c100423045.mefilter2,tp,LOCATION_MZONE,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_PENDULUM)) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100423045.meop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c100423045.mefilter1,tp,LOCATION_MZONE,0,c)
	local b1=g:IsExists(Card.IsType,1,c,TYPE_FUSION)
	local b2=g:IsExists(Card.IsType,1,c,TYPE_SYNCHRO)
	local b3=g:IsExists(Card.IsType,1,c,TYPE_XYZ)
	local b4=Duel.IsExistingMatchingCard(c100423045.mefilter2,tp,LOCATION_MZONE,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_PENDULUM)
	if b1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
	if b2 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(0,1)
		e2:SetValue(c100423045.actlimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
	if b3 then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetValue(c:GetBaseAttack()*2)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e3)
	end
	if b4 then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_PHASE+PHASE_END)
		e4:SetCountLimit(1)
		e4:SetCondition(c100423045.thcon)
		e4:SetOperation(c100423045.thop)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
	end
end
function c100423045.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c100423045.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100423045.thfilter,tp,LOCATION_DECK,0,1,nil)
end
function c100423045.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,100423045)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100423045.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
