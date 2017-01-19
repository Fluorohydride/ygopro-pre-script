--盆回し
--Festival Spinning
--Script by nekrozar
function c100912064.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100912064.target)
	e1:SetOperation(c100912064.operation)
	c:RegisterEffect(e1)
end
function c100912064.filter(c)
	return c:IsType(TYPE_FIELD) and c:IsSSetable()
end
function c100912064.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c100912064.filter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>1 end
end
function c100912064.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100912064.filter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100912064,0))
	local tg1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,tg1:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100912064,1))
	local tg2=g:Select(tp,1,1,nil)
	local fc1=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if fc1 then
		Duel.SendtoGrave(fc1,REASON_RULE)
		Duel.BreakEffect()
	end
	Duel.SSet(tp,tg1)
	local fc2=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
	if fc2 then
		Duel.SendtoGrave(fc2,REASON_RULE)
		Duel.BreakEffect()
	end
	Duel.SSet(1-tp,tg2)
	tg1:GetFirst():RegisterFlagEffect(100912064,RESET_EVENT+0x1fe0000,0,1)
	tg2:GetFirst():RegisterFlagEffect(100912064,RESET_EVENT+0x1fe0000,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetCondition(c100912064.con)
	e1:SetValue(c100912064.actlimit)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SSET)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetCondition(c100912064.con)
	e2:SetTarget(c100912064.setlimit)
	Duel.RegisterEffect(e2,tp)
end
function c100912064.cfilter(c)
	return c:GetSequence()==5 and c:IsFacedown() and c:GetFlagEffect(100912064)~=0
end
function c100912064.con(e)
	return Duel.IsExistingMatchingCard(c100912064.cfilter,e:GetHandlerPlayer(),LOCATION_SZONE,LOCATION_SZONE,1,nil)
end
function c100912064.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():GetFlagEffect(100912064)==0
end
function c100912064.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD) and c:GetFlagEffect(100912064)==0
end
