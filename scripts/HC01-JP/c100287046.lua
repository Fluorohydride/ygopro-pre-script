--運命の囚人
--
--Script by Trishula9
function c100287046.initial_effect(c)
	c:EnableCounterPermit(0x161)
	c:SetCounterLimit(0x161,3)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100287046)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c100287046.condition)
	e2:SetTarget(c100287046.target)
	e2:SetOperation(c100287046.operation)
	c:RegisterEffect(e2)
end
function c100287046.cfilter(c,tp)
	return c:IsLink(4) and c:IsSummonType(SUMMON_TYPE_LINK) and c:IsFaceup()
end
function c100287046.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100287046.cfilter,1,nil,tp)
end
function c100287046.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x161,1) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x161)
end
function c100287046.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x161,1)
		local ct=c:GetCounter(0x161)
		if ct==1 and Duel.SelectYesNo(tp,aux.Stringid(100287046,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
			local ac=Duel.AnnounceCard(tp)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
			e1:SetTarget(c100287046.distg1)
			e1:SetLabel(ac)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAIN_SOLVING)
			e2:SetCondition(c100287046.discon)
			e2:SetOperation(c100287046.disop)
			e2:SetLabel(ac)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e3:SetTarget(c100287046.distg2)
			e3:SetLabel(ac)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
		end
		local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100287046.spfilter1),tp,LOCATION_GRAVE,0,nil,e,tp)
		if ct==2 and g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(100287046,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg1=g1:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP)
		end
		local g2=Duel.GetMatchingGroup(c100287046.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp)
		if ct==3 and g2:GetCount()>0 and c:IsAbleToGrave() and Duel.SelectYesNo(tp,aux.Stringid(100287046,2))
			and Duel.SendtoGrave(c,REASON_EFFECT) and c:IsLocation(LOCATION_GRAVE) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg2=g2:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg2,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c100287046.distg1(e,c)
	local ac=e:GetLabel()
	if c:IsType(TYPE_SPELL+TYPE_TRAP) then
		return c:IsOriginalCodeRule(ac)
	else
		return c:IsOriginalCodeRule(ac) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
	end
end
function c100287046.distg2(e,c)
	local ac=e:GetLabel()
	return c:IsOriginalCodeRule(ac)
end
function c100287046.discon(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetLabel()
	return re:GetHandler():IsOriginalCodeRule(ac)
end
function c100287046.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function c100287046.spfilter1(c,e,tp)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100287046.spfilter2(c,e,tp)
	return c:IsLink(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end