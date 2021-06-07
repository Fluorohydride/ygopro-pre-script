--スターヴ・ヴェネミー・ドラゴン
--scripted by XyLeN
function c100278034.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),aux.FilterBoolFunction(Card.IsFusionType,TYPE_PENDULUM),true)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetOperation(c100278034.counter)
	c:RegisterEffect(e1)
	--atkdown
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c100278034.atktg)
	e2:SetValue(c100278034.atkval)
	c:RegisterEffect(e2)
	--reduce to 0
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100278034,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c100278034.rdcon)
	e3:SetOperation(c100278034.rdop)
	c:RegisterEffect(e3)
	--copy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100278034,1))
	e4:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,100278034)
	e4:SetCost(c100278034.copycost)
	e4:SetTarget(c100278034.copytg)
	e4:SetOperation(c100278034.copyop)
	c:RegisterEffect(e4)
	--to pzone
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(100278034,2))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(c100278034.pencon)
	e5:SetTarget(c100278034.pentg)
	e5:SetOperation(c100278034.penop)
	c:RegisterEffect(e5)
end
function c100278034.cfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c100278034.counter(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c100278034.cfilter,nil)
	if ct>0 then
		e:GetHandler():AddCounter(0x104f,ct)
	end
end
function c100278034.atktg(e,c)
	return not (c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK))
end
function c100278034.atkval(e,c)
	return Duel.GetCounter(0,1,1,0x104f)*-200
end
function c100278034.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c100278034.rdop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(100278034,3)) then
		Duel.Hint(HINT_CARD,0,100278034)
		Duel.ChangeBattleDamage(tp,0)
	end
end
function c100278034.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(100278034)==0 end
	e:GetHandler():RegisterFlagEffect(100278034,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c100278034.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c100278034.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsType(TYPE_TOKEN) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local code=tc:GetOriginalCodeRule()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		if not tc:IsType(TYPE_TRAPMONSTER) then
			local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
		end
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(100278034,4))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1)
		e2:SetLabelObject(e1)
		e2:SetLabel(cid)
		e2:SetOperation(c100278034.rstop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetValue(-500)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		local e4=e3:Clone() 
		e4:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e4) 
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_DISABLE)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e5)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_DISABLE_EFFECT)
		e6:SetValue(RESET_TURN_SET)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e6)
		Duel.Damage(1-tp,500,REASON_EFFECT)
	end
end
function c100278034.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	if cid~=0 then
		c:ResetEffect(cid,RESET_COPY)
		c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	end
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c100278034.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c100278034.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c100278034.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
