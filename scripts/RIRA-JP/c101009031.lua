--ボルテスター

--Script by nekrozar
function c101009031.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101009031,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,101009031)
	e1:SetCondition(c101009031.descon)
	e1:SetTarget(c101009031.destg)
	e1:SetOperation(c101009031.desop)
	c:RegisterEffect(e1)
end
function c101009031.descon(e,tp,eg,ep,ev,re,r,rp)
	local lg1=Duel.GetLinkedGroup(tp,1,1)
	local lg2=Duel.GetLinkedGroup(1-tp,1,1)
	lg1:Merge(lg2)
	return lg1 and lg1:IsContains(e:GetHandler())
end
function c101009031.desfilter1(c,mc)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:GetLinkedGroup():IsContains(mc)
end
function c101009031.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c101009031.desfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c101009031.desfilter2(g)
	local sg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		local fid=tc:GetFieldID()
		local lg=tc:GetLinkedGroup()
		local sc=lg:GetFirst()
		while sc do
			sc:RegisterFlagEffect(101009031,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1,fid)
			sg:AddCard(sc)
			sc=lg:GetNext()
		end
		tc=g:GetNext()
	end
	return sg
end
function c101009031.desfilter3(c,g)
	local res=false
	local tc=g:GetFirst()
	while tc do
		if c:GetFlagEffectLabel(101009031)==tc:GetFieldID() then res=true end
		tc=g:GetNext()
	end
	return res
end
function c101009031.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101009031.desfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetHandler())
	local lg=c101009031.desfilter2(g)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup()
		local sg=lg:Filter(c101009031.desfilter3,e:GetHandler(),og)
		while sg:GetCount()>0 do
			Duel.BreakEffect()
			lg=c101009031.desfilter2(sg)
			if Duel.Destroy(g,REASON_EFFECT)==0 then return end
			og=Duel.GetOperatedGroup()
			sg=lg:Filter(c101009031.desfilter3,e:GetHandler(),og)
		end
	end
end
