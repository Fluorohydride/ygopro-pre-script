--星向鳥
--
--Script by mercury233
function c101008024.initial_effect(c)
	--level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetCondition(c101008024.lvcon)
	e1:SetValue(c101008024.lvval)
	c:RegisterEffect(e1)
end
function c101008024.lvcon(e)
	return e:GetHandler():GetSequence()<5
end
function c101008024.lvval(e,c)
	local seq=c:GetSequence()
	if seq==0 then return 4 end
	if seq==4 then return 3 end
	if seq==2 then return 2 end
	return 1
end
