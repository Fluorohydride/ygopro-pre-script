--黒魔導強化
--Magic Expand
--Script by nekrozar
function c100909108.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c100909108.condition)
	e1:SetOperation(c100909108.activate)
	c:RegisterEffect(e1)
end
function c100909108.cfilter(c)
	return c:IsFaceup() and c:IsCode(46986414,38033121)
end
function c100909108.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100909108.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
end
function c100909108.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c100909108.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100909108.cfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local ct=g:GetCount()
	if ct>=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,c100909108.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.HintSelection(g)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetValue(1000)
			tc:RegisterEffect(e1)
		end
	end
	if ct>=2 then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAINING)
		e2:SetOperation(c100909108.chainop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e3:SetTargetRange(LOCATION_ONFIELD,0)
		e3:SetTarget(c100909108.indtg)
		e3:SetValue(c100909108.indval)
		e3:SetValue(1)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
	if ct>=3 then
		local g=Duel.GetMatchingGroup(c100909108.filter,tp,LOCATION_MZONE,0,nil)
		local tc=g:GetFirst()
		while tc do
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_IMMUNE_EFFECT)
			e4:SetValue(c100909108.efilter)
			e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e4:SetOwnerPlayer(tp)
			tc:RegisterEffect(e4)
			tc=g:GetNext()
		end
	end
end
function c100909108.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and ep~=tp then
		Duel.SetChainLimit(c100909108.chainlm)
	end
end
function c100909108.chainlm(e,rp,tp)
	return tp==rp
end
function c100909108.indtg(e,c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c100909108.indval(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c100909108.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
