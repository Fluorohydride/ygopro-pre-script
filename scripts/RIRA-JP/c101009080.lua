--泥仕合

--Script by nekrozar
function c101009080.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_CUSTOM+101009080)
	e1:SetCountLimit(1,101009080+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101009080.condition)
	e1:SetTarget(c101009080.target)
	e1:SetOperation(c101009080.activate)
	c:RegisterEffect(e1)
	if not c101009080.global_check then
		c101009080.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetCondition(c101009080.regcon)
		ge1:SetOperation(c101009080.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c101009080.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c101009080.regcon(e,tp,eg,ep,ev,re,r,rp)
	local v=0
	if eg:IsExists(c101009080.cfilter,1,nil,0) then v=v+1 end
	if eg:IsExists(c101009080.cfilter,1,nil,1) then v=v+2 end
	if v==0 then return false end
	e:SetLabel(({0,1,PLAYER_ALL})[v])
	return true
end
function c101009080.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+101009080,re,r,rp,ep,e:GetLabel())
end
function c101009080.condition(e,tp,eg,ep,ev,re,r,rp)
	return ev==PLAYER_ALL
end
function c101009080.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsPlayerCanDraw(1-tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,2)
end
function c101009080.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,2,REASON_EFFECT)
	Duel.Draw(1-tp,2,REASON_EFFECT)
end
