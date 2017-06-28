--直通断線
--Shut Line
--Scripted by Eerie Code
function c101002079.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c101002079.condition)
	e1:SetTarget(c101002079.target)
	e1:SetOperation(c101002079.activate)
	c:RegisterEffect(e1)
end
function c101002079.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_SZONE) then return false end
	local seq=c:GetSequence()
	if not Duel.IsChainNegatable(ev) or not (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) then return false end
	local rc=re:GetHandler()
	local rs=rc:GetSequence()
	if not rc:IsOnField() or (rc:IsLocation(LOCATION_SZONE) and rs>=5) then return false end
	if rc:IsControler(tp) then
		return rs==seq or (seq==1 and rs==5) or (seq==3 and rs==6)
	else
		return rs==4-seq or (seq==1 and rs==6) or (seq==3 and rs==5)
	end
end
function c101002079.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c101002079.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
