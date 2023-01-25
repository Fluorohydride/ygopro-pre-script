--時を裂く魔瞳
--Script by 奥克斯
function c101112067.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c101112067.condition)
	e1:SetOperation(c101112067.activate)
	e1:SetLabel(101112067)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c101112067.condition)
	e2:SetCost(c101112067.cost)
	e2:SetOperation(c101112067.operation)
	e2:SetLabel(101112067+100)
	c:RegisterEffect(e2)
end
function c101112067.condition(e)
	local ct=e:GetLabel()
	return ct>0 and Duel.GetFlagEffect(e:GetHandlerPlayer(),ct)==0
end
function c101112067.activate(e,tp,eg,ep,ev,re,r,rp)
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetCode(EFFECT_DRAW_COUNT)
	e0:SetTargetRange(1,0)
	e0:SetValue(2)
	Duel.RegisterEffect(e0,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c101112067.aclimit)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetValue(2)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterFlagEffect(tp,101112067,RESET_TEMP_REMOVE,0,1)
end
function c101112067.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_HAND and re:IsActiveType(TYPE_MONSTER)
end
function c101112067.filter(c)
	return c:IsCode(101112067) and c:IsDiscardable()
end
function c101112067.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c101112067.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	Duel.DiscardHand(tp,c101112067.filter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c101112067.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c101112067.nsumcon)
	e1:SetOperation(c101112067.nsumsuc)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,101112067+100,RESET_PHASE+PHASE_END,0,1)
end
function c101112067.nsumcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return ec and ec:IsControler(tp)
end
function c101112067.nsumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c101112067.efun)
end
function c101112067.efun(e,ep,tp)
	return ep==tp or not e:GetHandler():IsType(TYPE_MONSTER)
end