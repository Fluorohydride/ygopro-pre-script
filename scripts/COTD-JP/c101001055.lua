--エアークラック・ストーム
--Aircrack Storm
--Scripted by sahim
function c101001055.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE))	
	--Attack Counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c101001055.retcon)
	e2:SetOperation(c101001055.retop)
	c:RegisterEffect(e2)	
	--extra attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101001055,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c101001055.drcon)
	e3:SetCost(c101001055.cost)
	e3:SetOperation(c101001055.drop)
	c:RegisterEffect(e3)
end
function c101001055.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()~=e:GetHandler():GetEquipTarget()
end
function c101001055.retop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(101001055,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c101001055.counterfilter(c,eq)
	return c~=eq:GetEquipTarget()
end
function c101001055.drcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return e:GetHandler():GetEquipTarget()==ec and ec:GetBattleTarget():IsReason(REASON_BATTLE)
end
function c101001055.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(101001055)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_OATH+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c101001055.ftarget)
	e1:SetLabel(e:GetHandler():GetEquipTarget():GetFieldID())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101001055.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c101001055.drop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	e:GetHandler():GetEquipTarget():RegisterEffect(e1)
end
