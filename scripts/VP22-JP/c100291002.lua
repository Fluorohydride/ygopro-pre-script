--墓守の刻印

--Script by Chrono-Genex
function c100291002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c100291002.condition)
	e1:SetOperation(c100291002.activate)
	c:RegisterEffect(e1)
end
function c100291002.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function c100291002.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=Duel.SelectOption(tp,aux.Stringid(100291002,0),aux.Stringid(100291002,1),aux.Stringid(100291002,2))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,1)
	if op==0 then
		e1:SetDescription(aux.Stringid(100291002,0))
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetValue(c100291002.actlimit)
	elseif op==1 then
		e1:SetDescription(aux.Stringid(100291002,1))
		e1:SetCode(EFFECT_CANNOT_REMOVE)
		e1:SetTarget(c100291002.rmlimit)
	else
		e1:SetDescription(aux.Stringid(100291002,2))
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTarget(c100291002.splimit)
	end
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
function c100291002.actlimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE
end
function c100291002.rmlimit(e,c)
	return c:IsLocation(LOCATION_GRAVE)
end
function c100291002.splimit(e,c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER)
end
