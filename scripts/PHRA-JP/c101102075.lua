--インフェルニティ・サプレッション

--Scripted by mallu11
function c101102075.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101102075,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,101102075+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101102075.condition)
	e1:SetTarget(c101102075.target)
	e1:SetOperation(c101102075.activate)
	c:RegisterEffect(e1)
	--act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(c101102075.actcon)
	c:RegisterEffect(e2)
end
function c101102075.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0xb)
end
function c101102075.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c101102075.confilter,tp,LOCATION_MZONE,0,1,nil) then return end
	return ep==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
end
function c101102075.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c101102075.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsLevelAbove(1) and Duel.SelectYesNo(tp,aux.Stringid(101102075,1)) then
		Duel.BreakEffect()
		Duel.Damage(1-tp,re:GetHandler():GetLevel()*100,REASON_EFFECT)
	end
end
function c101102075.actcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)==0
end
