--極東权泉鄉
--Secret Hot Springs of the Far East
--Scripted by Kohana Sonogami
function c101104066.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--apply
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e2:SetCountLimit(1)
	e2:SetTarget(c101104066.effcon)
	e2:SetOperation(c101104066.effop)
	c:RegisterEffect(e2)
end
function c101104066.effcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c101104066.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=:GetHandler()
	local turn=Duel.GetTurnPlayer()
	if Duel.Recover(turn,1000,REASON_EFFECT)~=0 then
		--cannot disable summon
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_SZONE)
		Duel.RegisterEffect(e1,turn)
		local e2=e1:Clone() 
		e2:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
		Duel.RegisterEffect(e2,turn)
		--inactivatable
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_INACTIVATE)
		e3:SetRange(LOCATION_SZONE)
		e3:SetValue(c101104066.effectfilter)
		Duel.RegisterEffect(e3,turn)
		--protection
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e4:SetRange(LOCATION_FZONE)
		e4:SetTargetRange(LOCATION_SZONE,0)
		e4:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPELL+TYPE_TRAP))
		e4:SetValue(aux.tgoval)
		Duel.RegisterEffect(e4,turn)
		local e5=e4:Clone()
		e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e5:SetValue(aux.indoval)
		Duel.RegisterEffect(e5,turn)
	end
end
function c101104066.effectfilter(e,ct)
	local turn=Duel.GetTurnPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return turn==tp and te:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and te:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
end
