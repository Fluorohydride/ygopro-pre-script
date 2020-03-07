--Traptrix Genlisea
--Scripted by: XGlitchy30
function c100265054.initial_effect(c)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c100265054.efilter)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_LEAVE_GRAVE)
	e2:SetDescription(aux.Stringid(100265054,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100265054)
	e2:SetCost(c100265054.setcost)
	e2:SetTarget(c100265054.settg)
	e2:SetOperation(c100265054.setop)
	c:RegisterEffect(e2)
end
function c100265054.efilter(e,te)
	local c=te:GetHandler()
	return c:GetType()==TYPE_TRAP and c:IsSetCard(0x4c,0x89)
end
function c100265054.setfilter(c,tp,code)
	return c:IsSetCard(0x4c,0x89) and c:GetType()==TYPE_TRAP and c:IsSSetable() and (code==nil or c:GetCode()~=code)
		and (c:IsLocation(LOCATION_GRAVE) or Duel.IsExistingMatchingCard(c100265054.setfilter,tp,LOCATION_GRAVE,0,1,c,c:GetCode()))
end
function c100265054.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c100265054.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>=2 and Duel.IsExistingMatchingCard(c100265054.setfilter,tp,LOCATION_DECK,0,1,nil,tp,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
function c100265054.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g1=Duel.SelectMatchingCard(tp,c100265054.setfilter,tp,LOCATION_DECK,0,1,1,nil,tp,nil)
	if #g1<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100265054.setfilter),tp,LOCATION_GRAVE,0,1,1,g1:GetFirst(),tp,g1:GetFirst():GetCode())
	g1:Merge(g2)
	if #g1==2 then
		if Duel.SSet(tp,g1)==0 then return end
		local tc=g1:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(LOCATION_REMOVED)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			tc:RegisterEffect(e1)
			tc=g1:GetNext()
		end
	end
end
