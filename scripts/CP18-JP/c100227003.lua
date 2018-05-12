--飛行エレファント
--Flying Elephant
--Scripted by Eerie Code
function c100227003.initial_effect(c)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetCountLimit(1)
	e1:SetValue(c100227003.valcon)
	c:RegisterEffect(e1)
	--add win effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c100227003.effcon)
	e2:SetOperation(c100227003.effop)
	c:RegisterEffect(e2)
end
function c100227003.valcon(e,re,r,rp)
	local res=false
	if bit.band(r,REASON_EFFECT)~=0 and rp~=e:GetHandlerPlayer() then
		res=true
		e:GetHandler():RegisterFlagEffect(100227003,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
	return res
end
function c100227003.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(100227003)~=0
end
function c100227003.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100227003,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c100227003.wincon)
	e1:SetOperation(c100227003.winop)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN)
	c:RegisterEffect(e1)
end
function c100227003.wincon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetAttackTarget()==nil
end
function c100227003.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_FLYING_ELEPHANT=0x1d
	Duel.Win(tp,WIN_REASON_FLYING_ELEPHANT)
end
