--サイバネット・リフレッシュ
--Cynet Refresh
--Scripted by Eerie Code
function c101003067.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c101003067.condition)
	e1:SetTarget(c101003067.target)
	e1:SetOperation(c101003067.activate)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c101003067.immcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101003067.immtg)
	e2:SetOperation(c101003067.immop)
	c:RegisterEffect(e2)
end
function c101003067.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetAttacker():IsRace(RACE_CYBERSE)
end
function c101003067.desfilter(c)
	return c:GetSequence()<5
end
function c101003067.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c101003067.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c101003067.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101003067.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup()
		og:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(og)
		e1:SetOperation(c101003067.spop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c101003067.spfilter(c,e,tp)
	return c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_LINK) and c:IsLocation(LOCATION_GRAVE)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,c:GetControler())
end
function c101003067.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(c101003067.spfilter,nil,e,tp)
	if g:GetCount()==0 then return end
	for p=0,1 do
		local tg=g:Filter(Card.IsControler,nil,p)
		local ft=Duel.GetLocationCount(p,LOCATION_MZONE)
		if tg:GetCount()>ft then
			tg=tg:Select(tp,ft,ft,nil)
		end
		for tc in aux.Next(tg) do
			Duel.SpecialSummonStep(tc,0,tp,p,false,false,POS_FACEUP)
		end
	end
	Duel.SpecialSummonComplete()
end
function c101003067.immcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsActiveType(TYPE_MONSTER)
end
function c101003067.immfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_LINK)
end
function c101003067.immtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101003067.immfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c101003067.immop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101003067.immfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(c101003067.efilter)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c101003067.efilter(e,te)
	return te:GetOwner()~=e:GetHandler()
end
