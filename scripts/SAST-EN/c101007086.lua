--Time Thief Hack
--Script by JoyJ
function c101007086.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c101007086.xyztarget)
	e2:SetValue(c101007086.indesval)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c101007086.xyztarget)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101007086,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,101007086)
	e4:SetTarget(c101007086.atktg)
	e4:SetOperation(c101007086.atkop)
	c:RegisterEffect(e4)
end
function c101007086.indesval(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c101007086.xyztarget(e,c)
	return c:IsType(TYPE_XYZ) and c:IsStatus(STATUS_SPSUMMON_TURN)
end
function c101007086.filter(c)
	return c:IsFaceup() and c:GetOverlayCount()>0
end
function c101007086.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE)
		and chkc:IsControler(tp) and c101007086.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101007086.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101007086.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101007086.matfil(c,e)
	return c:GetOwner()~=e:GetHandlerPlayer()
end
function c101007086.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	local value=tc:GetOverlayCount()*300
	if tc:UpdateAttack(value,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,c)==value
		and tc:GetOverlayGroup():IsExists(c101007086.matfil,1,nil,e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
