--ヤマタコオロチ
--
--script by Raye Hikawa
function c101108032.initial_effect(c)
	--synclv
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_LEVEL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c101108032.synclv)
	c:RegisterEffect(e1)
	--gain effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCondition(c101108032.efcon)
	e2:SetOperation(c101108032.efop)
	c:RegisterEffect(e2)
end
function c101108032.synclv(e,c)
	local lv=e:GetHandler():GetLevel()
	return 8*65536+lv
end
function c101108032.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c101108032.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local reg=false
	if rc:IsLevelBelow(8) then
		--atkup
		local e1=Effect.CreateEffect(rc)
		e1:SetDescription(aux.Stringid(101108032,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(800)
		rc:RegisterEffect(e1,true)
		reg=true
	else
		--inflict damage
		local e2=Effect.CreateEffect(rc)
		e2:SetDescription(aux.Stringid(101108032,1))
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_PIERCE)
		e2:SetValue(DOUBLE_DAMAGE)
		rc:RegisterEffect(e2,true)
		reg=true
	end
	if reg then
		if not rc:IsType(TYPE_EFFECT) then
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetCode(EFFECT_ADD_TYPE)
			e0:SetValue(TYPE_EFFECT)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD)
			rc:RegisterEffect(e0,true)
		end
	end
end
