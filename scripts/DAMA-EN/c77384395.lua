--coded by Lyris
--Pazuzule
function c77384395.initial_effect(c)
	--P-Once per turn: You can target 1 card in your other Pendulum Zone; this card's Pendulum Scale becomes the Level of that Pendulum Monster Card until the end of this turn, also you cannot Special Summon for the rest of this turn, except by Pendulum Summon.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c77384395.target)
	e1:SetOperation(c77384395.operation)
	c:RegisterEffect(e1)
	--M-Pendulum Summons of your monsters cannot be negated.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSummonType,SUMMON_TYPE_PENDULUM))
	c:RegisterEffect(e2)
end
function c77384395.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_PZONE,0,1,c) end
	Duel.SetTargetCard(Duel.GetFirstMatchingCard(nil,tp,LOCATION_PZONE,0,c))
end
function c77384395.operation()
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LSCALE)
		e1:SetValue(tc:GetOriginalLevel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RSCALE)
		c:RegisterEffect(e2)
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c77384395.splimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c77384395.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return sumtype&SUMMON_TYPE_PENDULUM~=SUMMON_TYPE_PENDULUM
end
