--インスペクト・ボーダー
--Inspect Boarder
--Script by nekrozar
function c15397015.initial_effect(c)
	--summon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetCondition(c15397015.sumcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
	--activate limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c15397015.aclimit1)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	e4:SetCondition(c15397015.econ1)
	e4:SetValue(c15397015.elimit)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetOperation(c15397015.aclimit3)
	c:RegisterEffect(e5)
	local e7=e4:Clone()
	e7:SetCondition(c15397015.econ2)
	e7:SetTargetRange(0,1)
	c:RegisterEffect(e7)
end
function c15397015.sumcon(e)
	return Duel.GetFieldGroupCount(e:GetHandler():GetControler(),LOCATION_MZONE,0)>0
end
function c15397015.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION+TYPE_RITUAL+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM+TYPE_LINK)
end
function c15397015.typecount(c)
	return bit.band(c:GetType(),TYPE_FUSION+TYPE_RITUAL+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM+TYPE_LINK)
end
function c15397015.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp or not re:IsActiveType(TYPE_MONSTER) then return end
	e:GetHandler():RegisterFlagEffect(15397015,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c15397015.econ1(e)
	local g=Duel.GetMatchingGroup(c15397015.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=g:GetClassCount(c15397015.typecount)
	return e:GetHandler():GetFlagEffect(15397015)<ct
end
function c15397015.aclimit3(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsActiveType(TYPE_MONSTER) then return end
	e:GetHandler():RegisterFlagEffect(15397016,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c15397015.econ2(e)
	local g=Duel.GetMatchingGroup(c15397015.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil)
	local ct=g:GetClassCount(c15397015.typecount)
	return e:GetHandler():GetFlagEffect(15397016)<ct
end
function c15397015.elimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end
