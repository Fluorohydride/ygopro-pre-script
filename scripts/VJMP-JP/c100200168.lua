--DDイービル
--
--Script by DJ
function c100200168.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--disable (pzone)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetCountLimit(1)
	e1:SetCondition(c100200168.discon1)
	e1:SetTarget(c100200168.distg1)
	e1:SetOperation(c100200168.disop1)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetCondition(c100200168.atcon)
	c:RegisterEffect(e2)
	--disable (mzone)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100200168,1))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,100200168)
	e4:SetCondition(c100200168.discon2)
	e4:SetTarget(c100200168.distg2)
	e4:SetOperation(c100200168.disop2)
	c:RegisterEffect(e4)
end
function c100200168.disfilter1(c,e,tp)
	return c:GetSummonPlayer()==1-tp and c:IsSummonType(SUMMON_TYPE_PENDULUM) and (not e or c:IsRelateToEffect(e))
end
function c100200168.discon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100200168.disfilter1,1,nil,nil,tp)
end
function c100200168.distg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
end
function c100200168.disop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=eg:Filter(c100200168.disfilter1,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
function c100200168.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xaf)
end
function c100200168.atcon(e)
	return not Duel.IsExistingMatchingCard(c100200168.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c100200168.discon2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c100200168.disfilter2(c)
	return aux.disfilter1(c) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c100200168.distg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c100200168.disfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100200168.disfilter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c100200168.disfilter2,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c100200168.disop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
