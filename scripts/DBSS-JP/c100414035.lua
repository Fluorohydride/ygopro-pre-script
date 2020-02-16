--永久に輝けし黄金郷
--
--Script by JustFish
function c100414035.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,100414035+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100414035.condition)
	e1:SetCost(c100414035.cost)
	e1:SetTarget(c100414035.target)
	e1:SetOperation(c100414035.activate)
	c:RegisterEffect(e1)
end
function c100414035.filter(c)
	return c:IsSetCard(0x242) and c:IsFaceup()
end
function c100414035.condition(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
		and Duel.IsExistingMatchingCard(c100414035.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c100414035.cfilter(c)
	return c:IsRace(RACE_ZOMBIE) and (c:IsControler(tp) or c:IsFaceup()) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c100414035.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c100414035.cfilter,1,nil) end
	local sg=Duel.SelectReleaseGroup(tp,c100414035.cfilter,1,1,nil)
	Duel.Release(sg,REASON_COST)
end
function c100414035.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c100414035.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
