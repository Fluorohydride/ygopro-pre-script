--Smsm
--Kay Aye
--Underdog
function c101103092.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c101103092.disable)
	e2:SetCondition(c101103092.discon)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	--disable 2
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c101103092.disable)
	e3:SetCondition(c101103092.disconop)
	e3:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e3)
end


function c101103092.disable(e,c)
	return c:IsType(TYPE_EFFECT) or (c:GetOriginalType()&TYPE_EFFECT)==TYPE_EFFECT
end

function c101103092.discon(e,tp,eg,ep,ev,re,r,rp,chk)
	
	return Duel.GetTurnPlayer()== 0

end

function c101103092.disconop(e,tp,eg,ep,ev,re,r,rp,chk)
	
	return Duel.GetTurnPlayer()== 1

end

