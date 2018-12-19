--魂のペンデュラム
--
--Script by mercury233
function c100236027.initial_effect(c)
	c:EnableCounterPermit(0x152)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--scale
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100236027,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,100236027)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c100236027.target)
	e2:SetOperation(c100236027.operation)
	c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c100236027.counterop)
	c:RegisterEffect(e3)
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_PENDULUM))
	e4:SetValue(c100236027.atkval)
	c:RegisterEffect(e4)
	--extra pendulum
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(100236027,3))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCost(c100236027.expcost)
	e5:SetTarget(c100236027.exptg)
	e5:SetOperation(c100236027.expop)
	c:RegisterEffect(e5)
end
function c100236027.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_PZONE,0,2,nil) end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.SetTargetCard(g)
end
function c100236027.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	local tc=tg:GetFirst()
	while tc do
		Duel.HintSelection(Group.FromCards(tc))
		local sel=0
		if tc:GetLeftScale()<=1 then
			sel=Duel.SelectOption(tp,aux.Stringid(100236027,1))
		else
			sel=Duel.SelectOption(tp,aux.Stringid(100236027,1),aux.Stringid(100236027,2))
		end
		local ct=1
		if sel==1 then
			ct=-1
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LSCALE)
		e1:SetValue(ct)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_RSCALE)
		tc:RegisterEffect(e2)
		tc=tg:GetNext()
	end
end
function c100236027.cfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c100236027.counterop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c100236027.cfilter,1,nil,tp) then
		e:GetHandler():AddCounter(0x152,1)
	end
end
function c100236027.atkval(e,c)
	return e:GetHandler():GetCounter(0x152)*300
end
function c100236027.expcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x152,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x152,3,REASON_COST)
end
function c100236027.exptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,100236027)==0 end
end
function c100236027.expop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100236027,4))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(aux.TRUE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,100236027,RESET_PHASE+PHASE_END,0,1)
end
