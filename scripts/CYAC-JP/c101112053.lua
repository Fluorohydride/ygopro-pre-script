--铁兽的咆哮
--Script by 奥克斯
function c101112053.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMING_END_PHASE)
	e1:SetCountLimit(1,101112053+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c101112053.cost)
	e1:SetTarget(c101112053.target)
	e1:SetOperation(c101112053.activate)
	c:RegisterEffect(e1)
end
function c101112053.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c101112053.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c101112053.tagfilter(c,type)
	if type==nil then return false end
	local chk
	if type&TYPE_MONSTER~=0 then
		chk=c:GetAttack()>0
	elseif type&TYPE_SPELL~=0 then
		chk=aux.NegateMonsterFilter(c) and Duel.GetCurrentPhase()~=PHASE_DAMAGE 
	elseif type&TYPE_TRAP~=0 then 
		chk=c:IsAbleToHand() and Duel.GetCurrentPhase()~=PHASE_DAMAGE 
	end
	if chk==nil then return false end
	return c101112053.filter(c) and chk
end
function c101112053.atkfilter(c)
	return c101112053.filter(c) and c:GetAttack()>0
end
function c101112053.disfilter(c)
	return c101112053.filter(c) and aux.NegateMonsterFilter(c)
end
function c101112053.tfilter(c)
	return c101112053.filter(c) and c:IsAbleToHand()
end
function c101112053.tgfilter(c,tp)
	local chk
	if c:IsType(TYPE_MONSTER) then
		chk=Duel.IsExistingTarget(c101112053.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	elseif c:IsType(TYPE_SPELL) then
		chk=Duel.IsExistingTarget(c101112053.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.GetCurrentPhase()~=PHASE_DAMAGE 
	elseif c:IsType(TYPE_TRAP) then 
		chk=Duel.IsExistingTarget(c101112053.tfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.GetCurrentPhase()~=PHASE_DAMAGE 
	end
	if chk==nil then return false end
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0x14d) and chk
end
function c101112053.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101112053.tagfilter(chkc,e:GetLabel()) end
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c101112053.tgfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101112053.tgfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
	local type=g:GetFirst():GetType()
	e:SetLabel(type)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tag=Duel.SelectTarget(tp,c101112053.tagfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,type)
	if type&TYPE_MONSTER~=0 then
		e:SetCategory(CATEGORY_ATKCHANGE)
	elseif type&TYPE_SPELL~=0 then
		e:SetCategory(CATEGORY_DISABLE)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,tag,1,0,0)
	elseif type&TYPE_TRAP~=0 then 
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,tag,1,0,0)
	end
end
function c101112053.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local type=e:GetLabel()
	if type==nil then return end
	local chk
	local b1=false
	local b2=false
	local b3=false
	if type&TYPE_MONSTER~=0 then
		chk=tc:GetAttack()>0
		b1=true
	elseif type&TYPE_SPELL~=0 then
		chk=tc:IsFaceup() and tc:IsCanBeDisabledByEffect(e)
		b2=true
	elseif type&TYPE_TRAP~=0 then 
		chk=true
		b3=true
	end
	if tc:IsRelateToEffect(e) and chk then
		if b1==true then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
		if b2==true then
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
		if b3==true then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
