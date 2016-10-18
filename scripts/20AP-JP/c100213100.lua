--パワー・ウォール
--Power Wall
--Script by dest
function c100213100.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c100213100.condition)
	e1:SetTarget(c100213100.target)
	e1:SetOperation(c100213100.activate)
	c:RegisterEffect(e1)
end
function c100213100.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c100213100.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local val=math.ceil(Duel.GetBattleDamage(tp)/500)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,val) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,g)
end
function c100213100.activate(e,tp,eg,ep,ev,re,r,rp)
	local val=math.ceil(Duel.GetBattleDamage(tp)/500)
	Duel.DiscardDeck(tp,val,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	if og:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<val then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetOperation(c100213100.damop)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c100213100.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,0)
end
