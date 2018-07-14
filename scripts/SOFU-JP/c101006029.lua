--クマモール
--Bearrier
--Script by mercury233
function c101006029.initial_effect(c)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetCondition(c101006029.indcon)
	e1:SetTarget(c101006029.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101006029,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101006029.atkcon)
	e2:SetOperation(c101006029.atkop)
	c:RegisterEffect(e2)
end
function c101006029.indcon(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function c101006029.indtg(e,c)
	return c:GetSequence()<5 and c:IsFacedown()
end
function c101006029.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_SZONE) and c:GetPreviousSequence()<5 and c:IsPreviousPosition(POS_FACEDOWN) and c:IsReason(REASON_EFFECT)
end
function c101006029.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and eg:IsExists(c101006029.cfilter,1,nil,tp)
end
function c101006029.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
