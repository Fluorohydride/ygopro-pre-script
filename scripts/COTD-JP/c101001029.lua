--レスキューフェレット
--Rescue Ferret
--Script by nekrozar
--Effect is not fully implemented
function c101001029.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101001029,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c101001029.spcost)
	e1:SetTarget(c101001029.sptg)
	e1:SetOperation(c101001029.spop)
	c:RegisterEffect(e1)
end
function c101001029.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c101001029.ctfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c101001029.spfilter(c,e,tp,zone)
	return c:GetLevel()>0 and not c:IsCode(101001029) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c101001029.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local lg=Duel.GetMatchingGroup(c101001029.ctfilter,tp,LOCATION_MZONE,0,nil)
		local zone1=lg:GetSum(Card.GetLink)
		local zone2=lg:GetSum(Card.GetLinkedZone)
		local ct=5
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
		ct=math.min(ct,zone1)
		local g=Duel.GetMatchingGroup(c101001029.spfilter,tp,LOCATION_DECK,0,nil,e,tp,zone2)
		return ct>0 and g:CheckWithSumEqual(Card.GetLevel,6,1,ct)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c101001029.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lg=Duel.GetMatchingGroup(c101001029.ctfilter,tp,LOCATION_MZONE,0,nil)
	local zone1=lg:GetSum(Card.GetLink)
	local zone2=lg:GetSum(Card.GetLinkedZone)
	local ct=5
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	ct=math.min(ct,zone1)
	local g=Duel.GetMatchingGroup(c101001029.spfilter,tp,LOCATION_DECK,0,nil,e,tp,zone2)
	if ct>0 and g:CheckWithSumEqual(Card.GetLevel,6,1,ct) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectWithSumEqual(tp,Card.GetLevel,6,1,ct)
		local tc=sg:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP,zone2)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			tc:RegisterFlagEffect(101001029,RESET_EVENT+0x1fe0000,0,1,fid)
			tc=sg:GetNext()
		end
		Duel.SpecialSummonComplete()
		sg:KeepAlive()
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetCountLimit(1)
		e3:SetLabel(fid)
		e3:SetLabelObject(sg)
		e3:SetCondition(c101001029.descon)
		e3:SetOperation(c101001029.desop)
		Duel.RegisterEffect(e3,tp)
	end
end
function c101001029.desfilter(c,fid)
	return c:GetFlagEffectLabel(101001029)==fid
end
function c101001029.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c101001029.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c101001029.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c101001029.desfilter,nil,e:GetLabel())
	Duel.Destroy(tg,REASON_EFFECT)
end
