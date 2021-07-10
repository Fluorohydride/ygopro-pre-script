--Reloaded Cylinder
--scripted by XyLeN
function c100280070.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100280070.target)
	e1:SetOperation(c100280070.activate)
	c:RegisterEffect(e1)
	--inflict double damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100280070,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,100280070)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetCondition(c100280070.ddcon)
	e3:SetOperation(c100280070.ddop)
	c:RegisterEffect(e3)
end
function c100280070.setfilter(c)
	return c:IsCode(62279055) and c:IsSSetable()
end
function c100280070.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100280070.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c100280070.checkfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_DECK)
end
function c100280070.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100280070.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g:GetFirst())
		local og=Duel.GetOperatedGroup()
		if og:IsExists(c100280070.checkfilter,1,nil,tp) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			g:GetFirst():RegisterEffect(e1)
		end
	end
end
function c100280070.ddcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsCode(62279055)
end
function c100280070.ddop(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c100280070.damval)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function c100280070.damval(e,re,val,r,rp,rc)
	return val*2
end
