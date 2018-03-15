--終焉の覇王デミス
-- Demise, Supreme King of Armageddon
function c101005030.initial_effect(c)
	c:EnableReviveLimit()
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetValue(72426662)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c101005030.thcon)
	e2:SetTarget(c101005030.indtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c101005030.descost)
	e3:SetTarget(c101005030.destg)
	e3:SetOperation(c101005030.desop)
	c:RegisterEffect(e3)
end
function c101005030.indcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function c101005030.indtg(e,c)
	return c:IsType(TYPE_RITUAL)
end
function c101005030.mfilter(c)
	return not c:IsType(TYPE_RITUAL)
end
function c101005030.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	if chk==0 then return Duel.CheckLPCost(tp,2000) or (not mg:IsExists(c101005030.mfilter,1,nil) and c:GetSummonType()==SUMMON_TYPE_RITUAL) end
	if Duel.SelectYesNo(tp,aux.Stringid(27503418,0)) and not mg:IsExists(c101005030.mfilter,1,nil) then
		Duel.PayLPCost(tp,2000)
	else
		return true
	end
end
function c101005030.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	local ct=g:FilterCount(Card.IsControler,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*200)
end
function c101005030.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(g,REASON_EFFECT)
	local ct=Duel.GetOperatedGroup():FilterCount(Card.IsControler,nil,1-tp)
	if ct>0 then
		Duel.Damage(1-tp,ct*200,REASON_EFFECT)
	end
end
