--アラドヴァルの影霊衣
--Nekroz of Areadbhair
--LUA by Kohana Sonogami
function c100270014.initial_effect(c)
	c:EnableReviveLimit()
	--Cannot Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1)
	--Burialing
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100270014,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,100270014)
	e2:SetCost(c100270014.tgcost)
	e2:SetTarget(c100270014.tgtg)
	e2:SetOperation(c100270014.tgop)
	c:RegisterEffect(e2)
	--Negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100270014,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,100270014+100)
	e3:SetCondition(c100270014.negcon)
	e3:SetCost(c100270014.negcost)
	e3:SetTarget(c100270014.negtg)
	e3:SetOperation(c100270014.negop)
	c:RegisterEffect(e3)
end
function c100270014.mat_filter(c)
	return not c:IsLevel(10)
end
function c100270014.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c100270014.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xb4) and c:IsReleasableByEffect()
end
function c100270014.tgfilter(c)
	return c:IsSetCard(0xb4) and c:IsAbleToGrave()
end
function c100270014.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100270014.tgfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.CheckReleaseGroupEx(tp,c100270014.filter,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,1)
end
function c100270014.tgop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c100270014.tgfilter,tp,LOCATION_DECK,0,nil)
	if ct==0 then ct=1 end
	if ct>2 then ct=2 end
	local g=Duel.SelectReleaseGroupEx(tp,c100270014.filter,1,ct,nil)
	if g:GetCount()>0 then
		local rct=Duel.Release(g,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,c100270014.tgfilter,tp,LOCATION_DECK,0,1,rct,nil)
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
function c100270014.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_MONSTER)
end
function c100270014.negfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c100270014.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c100270014.negfilter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroupEx(tp,c100270014.negfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c100270014.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c100270014.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
