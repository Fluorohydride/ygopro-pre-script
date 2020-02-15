--電脳堺龍－龍々

--Scripted by mallu11
function c100264002.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,c100264002.mfilter,c100264002.xyzcheck,2,99)
	c:EnableReviveLimit()
	--cannot be effect target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(aux.tgoval)
	e1:SetCondition(c100264002.etcon)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100264002,0))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100264002)
	e2:SetCondition(c100264002.discon)
	e2:SetCost(c100264002.discost)
	e2:SetTarget(c100264002.distg)
	e2:SetOperation(c100264002.disop)
	c:RegisterEffect(e2)
end
function c100264002.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_MONSTER) and c:IsXyzLevel(xyzc,3)
end
function c100264002.xyzcheck(g)
	return g:GetClassCount(Card.GetRace)==1 and g:GetClassCount(Card.GetAttribute)==1
end
function c100264002.etcon(e)
	return e:GetHandler():GetOverlayCount()~=0
end
function c100264002.discon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	local attr=0
	while tc do
		attr=attr|tc:GetAttribute()
		tc=g:GetNext()
	end
	if g:GetCount()==0 or not re:IsActiveType(TYPE_MONSTER) then return false end
	local rc=re:GetHandler()
	return not rc:IsAttribute(attr)
end
function c100264002.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c100264002.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c100264002.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
