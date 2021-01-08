--ステイセイラ・ロマリン

--Scripted by mallu11
function c100200193.initial_effect(c)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100200193,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,100200193)
	e1:SetTarget(c100200193.indtg)
	e1:SetOperation(c100200193.indop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100200193,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,100200293)
	e2:SetCondition(c100200193.tgcon)
	e2:SetTarget(c100200193.tgtg)
	e2:SetOperation(c100200193.tgop)
	c:RegisterEffect(e2)
end
function c100200193.indfilter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c100200193.cfilter,tp,LOCATION_MZONE,0,1,c)
end
function c100200193.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_PLANT) and c:IsAbleToGrave()
end
function c100200193.indtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100200193.indfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c100200193.indfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c100200193.indfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_MZONE)
end
function c100200193.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local exc=nil
	if tc:IsRelateToEffect(e) then exc=tc end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100200193.cfilter,tp,LOCATION_MZONE,0,1,1,exc)
	local sc=g:GetFirst()
	if sc then
		Duel.HintSelection(g)
		if Duel.SendtoGrave(sc,REASON_EFFECT)~=0 and sc:IsLocation(LOCATION_GRAVE) and tc:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(100200193,2))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
			e1:SetCountLimit(1)
			e1:SetValue(c100200193.valcon)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end
function c100200193.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function c100200193.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c100200193.tgfilter(c)
	return c:IsLevelBelow(5) and c:IsRace(RACE_PLANT) and c:IsAbleToGrave()
end
function c100200193.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100200193.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c100200193.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100200193.tgfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
