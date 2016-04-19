--パンデミック・ドラゴン
--Pandemic Dragon
--Script by dest
function c100207006.initial_effect(c)
	--attack down
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetDescription(aux.Stringid(100207006,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c100207006.cost)
	e1:SetTarget(c100207006.target)
	e1:SetOperation(c100207006.operation)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100207006,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c100207006.destg)
	e2:SetOperation(c100207006.desop)
	c:RegisterEffect(e2)
	--attack -1k
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100201004,2))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c100207006.atkcon)
	e3:SetOperation(c100207006.atkop)
	c:RegisterEffect(e3)
end
function c100207006.filter(c)
	return c:IsFaceup() and c:IsAttackAbove(100)
end
function c100207006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,100) end
	local g=Duel.GetMatchingGroup(c100207006.filter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	local tg=g:GetMaxGroup(Card.GetAttack)
	local maxc=Duel.GetLP(tp)
	local maxpay=tg:GetFirst():GetAttack()
	if maxpay<maxc then maxc=maxpay end
	maxc=math.floor(maxc/100)*100
	local t={}
	for i=1,maxc/100 do
		t[i]=i*100
	end
	local cost=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,cost)
	e:SetLabel(cost)
end
function c100207006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc~=e:GetHandler() and c100207006.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c100207006.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
end
function c100207006.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100207006.filter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	local tc=g:GetFirst()
	local val=e:GetLabel()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(-val)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c100207006.desfilter(c,atk)
	return c:IsFaceup() and c:IsDestructable() and c:IsAttackBelow(atk)
end
function c100207006.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c100207006.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetAttack()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c100207006.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100207006.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c100207006.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function c100207006.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(-1000)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end
end
