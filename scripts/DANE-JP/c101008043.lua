--剛鬼ザ・ブレード・オーガ
--
--Script by mercury233
function c101008043.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xfc),2)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c101008043.atkval)
	c:RegisterEffect(e1)
	--multiatk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c101008043.atkcon)
	e2:SetCost(c101008043.atkcost)
	e2:SetTarget(c101008043.atktg)
	e2:SetOperation(c101008043.atkop)
	c:RegisterEffect(e2)
end
function c101008043.atkval(e,c)
	return c:GetLinkedGroupCount()*300
end
function c101008043.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c101008043.rfilter(c)
	return c:IsReleasable()
end
function c101008043.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return lg:IsExists(c101008043.rfilter,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=lg:FilterSelect(tp,c101008043.rfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c101008043.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK)==0 end
end
function c101008043.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
