--亡龍の旋律
--
--Scripted by Lsty
function c101008063.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101008063.target)
	e1:SetOperation(c101008063.activate)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetLabelObject(e1)
	e2:SetOperation(c101008063.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetLabelObject(e2)
	e3:SetCondition(c101008063.damcon)
	e3:SetOperation(c101008063.damop)
	c:RegisterEffect(e3)
	--self destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c101008063.descon)
	e4:SetOperation(c101008063.desop)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c101008063.indcon)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end
function c101008063.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c101008063.activate(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	e:SetLabel(ac)
	e:GetHandler():SetHint(CHINT_CARD,ac)
end
function c101008063.regop(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetFirst():IsCode(e:GetLabelObject():GetLabel()) then
		e:GetHandler():RegisterFlagEffect(101008063,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
		e:SetLabel(ep)
	end
end
function c101008063.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(101008063)~=0
end
function c101008063.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=e:GetLabelObject():GetLabel()
	Duel.Hint(HINT_CARD,0,101008063)
	Duel.SetLP(p,math.ceil(Duel.GetLP(p)/2))
	c:RegisterFlagEffect(101008063+100,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c101008063.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(101008063+100)~=0
end
function c101008063.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
function c101008063.indcon(e)
	return Duel.GetFieldGroupCount(e:GetOwnerPlayer(),0,LOCATION_MZONE)>0
end
