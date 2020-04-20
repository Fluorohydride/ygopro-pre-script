--饕餮龙
function c101012083.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c101012083.matfilter,2)
	--effect gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101012083.regcon)
	e1:SetOperation(c101012083.regop)
	c:RegisterEffect(e1)
end
function c101012083.matfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function c101012083.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c101012083.condition(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c101012083.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c101012083.condition2(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.GetTurnPlayer()==e:GetControler()
end
function c101012083.aclimit2(e,re,tp)
	return re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP)
end
function c101012083.condition3(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)) and Duel.GetTurnPlayer()==e:GetControler()
end
function c101012083.aclimit3(e,re,tp)
	return re:GetHandler():IsLocation(LOCATION_GRAVE)
end
function c101012083.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetMaterial():FilterCount(Card.IsLinkType,nil,TYPE_FUSION)>0 then
		--activate limit - fusion -> monster
		local efus=Effect.CreateEffect(c)
		efus:SetType(EFFECT_TYPE_FIELD)
		efus:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		efus:SetCode(EFFECT_CANNOT_ACTIVATE)
		efus:SetRange(LOCATION_MZONE)
		efus:SetReset(RESET_EVENT+RESETS_STANDARD)
		efus:SetTargetRange(0,1)
		efus:SetCondition(c101012083.condition)
		efus:SetValue(c101012083.aclimit)
		c:RegisterEffect(efus)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(101012083,0))
	end
	if c:GetMaterial():FilterCount(Card.IsLinkType,nil,TYPE_SYNCHRO)>0 then
		--activate limit - synchro -> spell/trap
		local esyn=Effect.CreateEffect(c)
		esyn:SetType(EFFECT_TYPE_FIELD)
		esyn:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		esyn:SetCode(EFFECT_CANNOT_ACTIVATE)
		esyn:SetRange(LOCATION_MZONE)
		esyn:SetReset(RESET_EVENT+RESETS_STANDARD)
		esyn:SetTargetRange(0,1)
		esyn:SetCondition(c101012083.condition2)
		esyn:SetValue(c101012083.aclimit2)
		c:RegisterEffect(esyn)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(101012083,1))
	end
	if c:GetMaterial():FilterCount(Card.IsLinkType,nil,TYPE_XYZ)>0 then
		--activate limit - XYZ -> grave
		local esyn=Effect.CreateEffect(c)
		exyz:SetType(EFFECT_TYPE_FIELD)
		exyz:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		exyz:SetCode(EFFECT_CANNOT_ACTIVATE)
		exyz:SetRange(LOCATION_MZONE)
		exyz:SetReset(RESET_EVENT+RESETS_STANDARD)
		exyz:SetTargetRange(0,1)
		exyz:SetCondition(c101012083.condition3)
		exyz:SetValue(c101012083.aclimit3)
		c:RegisterEffect(exyz)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(101012083,2))
	end
end