--エンタメデュエル
--Dueltainment
--Scripted by Eerie Code
function c100213060.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c100213060.spcon1)
	e2:SetOperation(c100213060.drop1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCondition(c100213060.spcon2)
	e3:SetOperation(c100213060.drop2)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_BATTLED)
	e4:SetCondition(c100213060.btcon1)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_BATTLED)
	e5:SetCondition(c100213060.btcon2)
	c:RegisterEffect(e5)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_FZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	local e6=e2:Clone()
	e6:SetCode(EVENT_CHAIN_SOLVING)
	e6:SetCondition(c100213060.chcon1)
	c:RegisterEffect(e6)
	local e7=e3:Clone()
	e7:SetCode(EVENT_CHAIN_SOLVING)
	e7:SetCondition(c100213060.chcon2)
	c:RegisterEffect(e7)
	local e8=e2:Clone()
	e8:SetCode(EVENT_CHAIN_SOLVED)
	e8:SetCondition(c100213060.tosscon1)
	c:RegisterEffect(e8)
	local e9=e3:Clone()
	e9:SetCode(EVENT_CHAIN_SOLVED)
	e9:SetCondition(c100213060.tosscon2)
	c:RegisterEffect(e9)
	local ea=e2:Clone()
	ea:SetCode(EVENT_DAMAGE)
	ea:SetCondition(c100213060.damcon1)
	c:RegisterEffect(ea)
	local eb=e3:Clone()
	eb:SetCode(EVENT_DAMAGE)
	eb:SetCondition(c100213060.damcon2)
	c:RegisterEffect(eb)
end
function c100213060.spfilter(c,tp)
	return c:GetSummonPlayer()==tp
end
function c100213060.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==5 and eg:IsExists(c100213060.spfilter,1,nil,tp) and eg:GetClassCount(Card.GetLevel)==5
end
function c100213060.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()==5 and eg:IsExists(c100213060.spfilter,1,nil,1-tp) and eg:GetClassCount(Card.GetLevel)==5
end
function c100213060.drop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,100213060)
	Duel.Draw(tp,2,REASON_EFFECT)
end
function c100213060.drop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,100213060)
	Duel.Draw(1-tp,2,REASON_EFFECT)
end
function c100213060.btcon1(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:IsControler(1-tp) then a,d=d,a end
	if a then
		a:RegisterFlagEffect(100213060,RESET_EVENT+0x1fe0000,0,1)
		return a:GetFlagEffect(100213060)==5
	else return false end
end
function c100213060.btcon2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:IsControler(tp) then a,d=d,a end
	if a then
		a:RegisterFlagEffect(100213060,RESET_EVENT+0x1fe0000,0,1)
		return a:GetFlagEffect(100213060)==5
	else return false end
end
function c100213060.chcon1(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and Duel.GetCurrentChain()>=5 and e:GetHandler():GetFlagEffect(1)>0
end
function c100213060.chcon2(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.GetCurrentChain()>=5 and e:GetHandler():GetFlagEffect(1)>0
end
function c100213060.tosscon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTossedCoinCount(tp)+Duel.GetTossedDiceCount(tp)>=5 and e:GetHandler():GetFlagEffect(1)>0
end
function c100213060.tosscon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTossedCoinCount(1-tp)+Duel.GetTossedDiceCount(1-tp)>=5 and e:GetHandler():GetFlagEffect(1)>0
end
function c100213060.damcon1(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.GetLP(tp)<=500
end
function c100213060.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and Duel.GetLP(1-tp)<=500
end
