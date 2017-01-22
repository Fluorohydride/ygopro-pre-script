--ドン・サウザンドの契約
--Contract with Don Thousand
--Scripted by Eerie Code
function c100213058.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100213058+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100213058.target)
	e1:SetOperation(c100213058.activate)
	c:RegisterEffect(e1)
	--flag drawn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DRAW)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c100213058.drop)
	c:RegisterEffect(e2)
	--cannot summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,0)
	e3:SetCondition(c100213058.scon1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetTargetRange(0,1)
	e5:SetCondition(c100213058.scon2)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e6)
end
function c100213058.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)>1000 and Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetLP(1-tp)>1000 and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function c100213058.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local lp0=Duel.GetLP(0)
	if lp0>1000 then
		Duel.SetLP(0,lp0-1000)
		Duel.Draw(0,1,REASON_EFFECT)
	end
	local lp1=Duel.GetLP(1)
	if lp1>1000 then
		Duel.SetLP(1,lp1-1000)
		Duel.Draw(1,1,REASON_EFFECT)
	end
end
function c100213058.drop(e,tp,eg,ep,ev,re,r,rp)
	if not eg then return end
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		if tc:IsType(TYPE_SPELL) then
			tc:RegisterFlagEffect(100213058,RESET_EVENT+0x1fe0000,0,1)
		end
		tc=eg:GetNext()
	end
end
function c100213058.sfilter(c)
	return c:IsPublic() and c:GetFlagEffect(100213058)>0
end
function c100213058.scon1(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c100213058.sfilter,tp,LOCATION_HAND,0,1,nil)
end
function c100213058.scon2(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c100213058.sfilter,tp,0,LOCATION_HAND,1,nil)
end
