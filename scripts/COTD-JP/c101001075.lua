--絶縁の落とし穴
--Breakoff Trap Hole
--Script by nekrozar
function c101001075.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c101001075.condition)
	e1:SetTarget(c101001075.target)
	e1:SetOperation(c101001075.activate)
	c:RegisterEffect(e1)
end
function c101001075.cfilter(c)
	return c:IsType(TYPE_LINK) and bit.band(c:GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c101001075.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101001075.cfilter,1,nil)
end
function c101001075.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c101001075.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	local tg=g:Filter(c101001075.filter,nil)
	local tc=tg:GetFirst()
	while tc do
		local lg=tc:GetLinkedGroup()
		if lg:GetCount()>0 then
			lg:AddCard(tc)
			g:Sub(lg)
		end
		tc=tg:GetNext()
	end
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c101001075.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	local tg=g:Filter(c101001075.filter,nil)
	local tc=tg:GetFirst()
	while tc do
		local lg=tc:GetLinkedGroup()
		if lg:GetCount()>0 then
			lg:AddCard(tc)
			g:Sub(lg)
		end
		tc=tg:GetNext()
	end
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
