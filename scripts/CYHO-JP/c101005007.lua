--神樹のパラディオン

--Script by nekrozar
function c101005007.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_DEFENSE,0)
	e1:SetCountLimit(1,101005007)
	e1:SetCondition(c101005007.spcon)
	e1:SetValue(c101005007.spval)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCountLimit(1,101005107)
	e2:SetTarget(c101005007.reptg)
	e2:SetValue(c101005007.repval)
	e2:SetOperation(c101005007.repop)
	c:RegisterEffect(e2)
end
function c101005007.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=Duel.GetLinkedZone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c101005007.spval(e,c)
	return 0,Duel.GetLinkedZone(c:GetControler())
end
function c101005007.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsSetCard(0x217) and not c:IsReason(REASON_REPLACE)
end
function c101005007.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c101005007.repfilter,1,c,tp) and c:IsAbleToRemove()
		and Duel.GetFlagEffect(tp,101005007)==0 end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c101005007.repval(e,c)
	return c101005007.repfilter(c,e:GetHandlerPlayer())
end
function c101005007.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,101005007,RESET_PHASE+PHASE_END,0,1)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
