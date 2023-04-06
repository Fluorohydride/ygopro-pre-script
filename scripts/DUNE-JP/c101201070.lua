-- New World Formation
-- Scripted by Yummy Catnip
local s,id,o=GetID()
function s.initial_effect(c)
	--Set 1 Spell/Trap that mentions "56099748" from your GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetTarget(s.sttarg)
	e1:SetOperation(s.stoper)
	c:RegisterEffect(e1)
	--Shuffle 3 Spells/Traps that mention "56099748" from GY into the Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.tdtarg)
	e2:SetOperation(s.tdoper)
	c:RegisterEffect(e2)
end
s.listed_names={56099748}
-- e1 Effect Code
function s.sfilter(c)
	return aux.IsCodeListed(c,56099748) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function s.sttarg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.setfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.sfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,s.sfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,tp,0)
end
function s.stoper(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SSet(tp,tc)>0 then
		local c_type=(tc:IsType(TYPE_QUICKPLAY) and EFFECT_QP_ACT_IN_SET_TURN)
			or (tc:IsType(TYPE_TRAP) and EFFECT_TRAP_ACT_IN_SET_TURN)
			or 0
		if c_type==0 then return end
		--Can be activated this turn
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,2))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(c_type)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
-- e2 Effect Code
function s.tdfilter(c)
	return aux.IsCodeListed(c,56099748) and c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsAbleToDeck() and not c:IsCode(id)
end
function s.tdtarg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.tdfilter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.tdfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,tp,0)
end
function s.tdoper(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #tg>0 then
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
--[[ Text
You can only use the 1st and 2nd effect of this card’s name each once per turn.
(1) Target 1 Spell/Trap that mentions “Visas Starfrost” in your GY; Set it, and if it is a Trap or Quick-Play Spell, you can activate it this turn
(2) You can banish this card from your GY, then target 3 Spells/Traps that mention “Visas Starfrost” in your GY, except “New World Formation”; shuffle them into the Deck. ]]