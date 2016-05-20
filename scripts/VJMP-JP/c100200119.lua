--パッチワーク・ファーニマル
--Fluffal Patchwork
--Script by mercury233
function c100200119.initial_effect(c)
	--setcode
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetValue(0xad)
	c:RegisterEffect(e1)
	--fusion substitute
	if Card.CheckFusionSubstitute then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_FUSION_SUBSTITUTE)
		e2:SetCondition(c100200119.subcon)
		e2:SetValue(c100200119.subval)
		c:RegisterEffect(e2)
	else
		--temp, make it can be substitute but can only be use to fusion Frightfur, and this effect can be turn on and off
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_FUSION_SUBSTITUTE)
		e2:SetCondition(c100200119.tempsubcon)
		c:RegisterEffect(e2)
		--cannot be material
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e3:SetValue(c100200119.templimit)
		c:RegisterEffect(e3)
		--toggle
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_IGNITION)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetOperation(c100200119.tempop)
		c:RegisterEffect(e4)
	end
end
function c100200119.subcon(e)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE)
end
function c100200119.subval(e,c)
    return c:IsSetCard(0xad)
end

function c100200119.tempsubcon(e)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:GetFlagEffect(100200119)>0
end
function c100200119.templimit(e,c)
	if not c then return false end
	return not (c:IsSetCard(0xad) or e:GetHandler():GetFlagEffect(100200119)==0)
end
function c100200119.tempop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(100200119)==0 then
		c:RegisterFlagEffect(100200119,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(100200119,0))
	else
		c:ResetFlagEffect(100200119)
	end
end
