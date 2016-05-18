--マグネット・フォース
--Magnet Force
--Script by mercury233
function c100417006.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c100417006.activate)
	c:RegisterEffect(e1)
end
function c100417006.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c100417006.etarget)
	e1:SetValue(c100417006.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c100417006.etarget(e,c)
	return c:GetOriginalRace()==RACE_MACHINE or c:GetOriginalRace()==RACE_ROCK
end
function c100417006.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner() --it don't work
		and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
