--赤酢の踏切
--Script by 神数不神
function c101111079.initial_effect(c)
	c:SetUniqueOnField(1,0,101111079)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c101111079.condtion)
	e1:SetTarget(c101111079.target)
	e1:SetOperation(c101111079.operation)
	c:RegisterEffect(e1)
	--disable field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetValue(c101111079.disval)
	c:RegisterEffect(e2)
end
function c101111079.disval(e,tp)
	local c=e:GetHandler()
	return c:GetColumnZone(LOCATION_ONFIELD,0)
end
function c101111079.condtion(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_SZONE) and c:IsFacedown()
		and c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)~=nil
end
function c101111079.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetColumnGroup()
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c101111079.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetColumnGroup()
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
