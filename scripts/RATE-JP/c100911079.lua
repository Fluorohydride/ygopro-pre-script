--スウィッチヒーロー
--Switch Hero
--Script by mercury233
function c100911079.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100911079,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c100911079.target)
	e1:SetOperation(c100911079.activate)
	c:RegisterEffect(e1)
end
function c100911079.filter(c)
	return not c:IsAbleToChangeControler()
end
function c100911079.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g1:GetCount()==g2:GetCount()
		and g:FilterCount(c100911079.filter,nil)==0 end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),0,0)
end
function c100911079.filter2(c)
	return not c:IsAbleToChangeControler() or not c:IsImmuneToEffect(e)
end
function c100911079.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	if g1:GetCount()~=g2:GetCount() or g:FilterCount(c100911079.filter2,nil)>0 then return end
	local sg1=g1:Filter(Card.IsAbleToChangeControler,nil)
	local sg2=g2:Filter(Card.IsAbleToChangeControler,nil)
	local n1=sg1:GetCount()
	local n2=sg2:GetCount()
	if n1~=n2 then
		local ct1=Duel.GetLocationCount(tp,LOCATION_MZONE)+n1
		local ct2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)+n2
		if n1>ct2 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONTROL)
			sg1=g1:FilterSelect(1-tp,Card.IsAbleToChangeControler,ct2,ct2,nil)
		end
		if n2>ct1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
			sg2=g2:FilterSelect(tp,Card.IsAbleToChangeControler,ct1,ct1,nil)
		end
	end
	local a=sg1:GetFirst()
	local b=sg2:GetFirst()
	while a and b do
		Duel.SwapControl(a,b)
		a=sg1:GetNext()
		b=sg2:GetNext()
	end
	while a do
		Duel.GetControl(a,1-tp)
		a=sg1:GetNext()
	end
	while b do
		Duel.GetControl(b,tp)
		b=sg2:GetNext()
	end
end
