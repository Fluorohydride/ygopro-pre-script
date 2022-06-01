--Libromancer Bonded
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,45001322,88106656)
	--This card can be used to Ritual Summon any "Libromancer" Ritual Monster. You must also Tribute monsters from your hand or field whose total Levels equal or exceed the Level of the Ritual Monster you Ritual Summon. If you Ritual Summon "Libromancer Fireburst" with this effect, using "Libromancer Firestarter" on the field, it cannot be destroyed, or banished, by card effects.
	aux.AddRitualProcGreater(c,aux.FilterBoolFunction(Card.IsSetCard,0x17c),LOCATION_HAND,nil,nil,false,s.op)
end
function s.filter(c)
	return c:IsCode(45001322) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function s.op(e,tp,eg,ep,ev,re,r,rp,tc,g)
	if not (g:IsExists(s.filter,1,nil) and tc:IsCode(88106656)) then return end
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(1)
	tc:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetTarget(s.rmlimit)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
end
function s.rmlimit(e,c,tp,r,re)
	return c==e:GetHandler() and r&REASON_EFFECT>0
end
