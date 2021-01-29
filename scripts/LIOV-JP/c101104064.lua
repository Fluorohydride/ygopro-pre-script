--皆既月蝕の書

--Scripted by TanakaKotoha
function c101104064.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_BATTLE_PHASE,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_PHASE)
	e1:SetCost(c101104064.poscost)
	e1:SetTarget(c101104064.postg)
	e1:SetOperation(c101104064.posop)
	c:RegisterEffect(e1)
end
function c101104064.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c101104064.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c101104064.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c101104064.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101104064.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c101104064.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,2,2,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,2,0,0)
end
function c101104064.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
