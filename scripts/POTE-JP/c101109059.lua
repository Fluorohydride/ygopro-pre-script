--肆世壊からの天跨
--
--Script by Trishula9
function c101109059.initial_effect(c)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101109059,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101109059+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101109059.atktg)
	e1:SetOperation(c101109059.atkop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101109059,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,101109059+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c101109059.discon)
	e2:SetTarget(c101109059.distg)
	e2:SetOperation(c101109059.disop)
	c:RegisterEffect(e2)
end
function c101109059.atkfilter(c)
	return c:IsSetCard(0x17a) or c:IsCode(56099748)
end
function c101109059.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c101109059.atkfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c101109059.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2)
end
function c101109059.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()<2 then return end
	local sc1=tg:Filter(Card.IsControler,nil,tp):GetFirst()
	local sc2=tg:Filter(Card.IsControler,nil,1-tp):GetFirst()
	if not sc1 or not sc2 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(math.max(sc2:GetAttack(),sc2:GetDefense()))
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	sc1:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	sc1:RegisterEffect(e2)
end
function c101109059.disfilter(c)
	return (c:IsSetCard(0x17a) or c:IsCode(56099748)) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c101109059.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c101109059.disfilter,1,nil) and Duel.IsChainDisablable(ev)
end
function c101109059.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c101109059.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
