-- New World Full of Stars
-- Scripted by Yummy Catnip
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,56099748)
	-- Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	-- Prevent the first time a monster would destroyed by battle while you control "Visas Starfrost"
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(s.indcon)
	e1:SetValue(s.indval)
	c:RegisterEffect(e1)
		--Shuffle monster into the Deck during your End Phase or add it to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetHintTiming(TIMING_END_PHASE,0)
	e2:SetCondition(s.tdcond)
	e2:SetTarget(s.tdtarg)
	e2:SetOperation(s.tdoper)
	c:RegisterEffect(e2)
end
-- e1 Effect Code
function s.vfilter(c)
	return c:IsFaceup() and c:IsCode(56099748)
end
function s.indcon(e)
	return Duel.IsExistingMatchingCard(s.vfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function s.indval(e,re,r,rp)
	if (r&REASON_BATTLE)~=0 then
		return 1
	else
		return 0
	end
end
-- e2 Effect Code
function s.tdcond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_END
		and Duel.IsExistingMatchingCard(s.vfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.tdfilter(c,tohand)
	return c:IsType(TYPE_MONSTER) and (c:IsAbleToDeck() or (tohand and c:IsAbleToHand()))
end
function s.tsfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TUNER) and c:IsType(TYPE_SYNCHRO)
end
function s.tdtarg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tohand=Duel.IsExistingMatchingCard(s.tsfilter,tp,LOCATION_MZONE,0,1,nil)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and s.tdfilter(chkc,tohand) end
	if chk==0 then return Duel.IsExistingTarget(s.tdfilter,tp,LOCATION_GRAVE,0,1,nil,tohand) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil,tohand)
	if tohand and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,0)
		e:SetLabel(1)
	else
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,tp,0)
		e:SetLabel(0)
	end
end
function s.tdoper(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local op=e:GetLabel()
	if not tc:IsRelateToEffect(e) then return end
	if op==1 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end