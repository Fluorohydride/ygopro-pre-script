--旋風機ストリボーグ
--Whirlwind Machine Striborg
--Scripted by Eerie Code
function c101002037.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101002037,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c101002037.thcost)
	e1:SetTarget(c101002037.thtg)
	e1:SetOperation(c101002037.thop)
	c:RegisterEffect(e1)
	--tribute check
	if not c101002037.global_check then
		c101002037.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		ge1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		ge1:SetValue(LOCATION_HAND)
		ge1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		ge1:SetTarget(c101002037.trtg)
		Duel.RegisterEffect(ge1,tp)
	end
end
function c101002037.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0) end
	Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_COST,nil)
end
function c101002037.thfilter(c,hc)
	return c:IsAbleToHand() and aux.checksamecolumn(c,hc)
end
function c101002037.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c101002037.thfilter,tp,0,LOCATION_ONFIELD,nil,e:GetHandler())
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c101002037.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Duel.GetMatchingGroup(c101002037.thfilter,tp,0,LOCATION_ONFIELD,nil,c)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end
function c101002037.trtg(e,c)
	local rc=c:GetReasonCard()
	return c:IsReason(REASON_RELEASE) and rc and rc:IsCode(101002037)
end
