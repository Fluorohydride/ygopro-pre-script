--天威の龍拳聖

--Scripted by nekrozar
function c100200169.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c100200169.lcheck)
	c:EnableReviveLimit()
	--indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(c100200169.indval)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100200169,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100200169)
	e2:SetCondition(c100200169.descon)
	e2:SetTarget(c100200169.destg)
	e2:SetOperation(c100200169.desop)
	c:RegisterEffect(e2)
end
function c100200169.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_LINK)
end
function c100200169.indval(e,c)
	return c:IsType(TYPE_EFFECT)
end
function c100200169.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c100200169.descon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c100200169.filter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c100200169.ctfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_EFFECT))
		or (c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and not c:IsType(TYPE_EFFECT))
end
function c100200169.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100200169.ctfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c100200169.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c100200169.filter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100200169.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c100200169.ctfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c100200169.filter,tp,0,LOCATION_ONFIELD,1,ct,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
