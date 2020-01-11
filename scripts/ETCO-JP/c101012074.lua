--スカーレッド・レイン

--Scripted by mallu11
function c101012074.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101012074,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(c101012074.condition)
	e1:SetTarget(c101012074.target)
	e1:SetOperation(c101012074.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101012074,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101012074)
	e2:SetCondition(c101012074.thcon)
	e2:SetTarget(c101012074.thtg)
	e2:SetOperation(c101012074.thop)
	c:RegisterEffect(e2)
end
function c101012074.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsLevelAbove(8)
end
function c101012074.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101012074.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101012074.filter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c101012074.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c101012074.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()<=0 then return false end
	local tg=g:GetMaxGroup(Card.GetLevel)
	local mg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	mg:Sub(tg)
	local rg=mg:Filter(Card.IsAbleToRemove,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c101012074.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and rg:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,rg:GetCount(),0,0)
end
function c101012074.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101012074.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()<=0 then return end
	local tg=g:GetMaxGroup(Card.GetLevel)
	local mg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	mg:Sub(tg)
	local rg=mg:Filter(Card.IsAbleToRemove,nil)
	if rg:GetCount()>0 then
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
	g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c101012074.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c101012074.efilter(e,re)
	return e:GetHandler()~=re:GetOwner()
end
function c101012074.thfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_SYNCHRO)
		and c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:IsControler(tp)
end
function c101012074.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101012074.thfilter,1,nil,tp)
end
function c101012074.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c101012074.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
