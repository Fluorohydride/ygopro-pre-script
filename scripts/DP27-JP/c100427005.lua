--パワー・ツール・ブレイバー・ドラゴン
--
--Script by Trishula9
function c100427005.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,100427005)
	e1:SetTarget(c100427005.eqtg)
	e1:SetOperation(c100427005.eqop)
	c:RegisterEffect(e1)
	--pos or neg
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,100427005+100)
	e2:SetCondition(c100427005.pncon)
	e2:SetCost(c100427005.pncost)
	e2:SetTarget(c100427005.pntg)
	e2:SetOperation(c100427005.pnop)
	c:RegisterEffect(e2)
end
function c100427005.eqfilter(c,ec,tp)
	return c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec) and c:CheckUniqueOnField(tp,LOCATION_SZONE) and not c:IsForbidden()
end
function c100427005.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c100427005.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e:GetHandler(),tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c100427005.eqop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local c=e:GetHandler()
	if ft<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100427005.eqfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,c,tp)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,math.min(ft,3))
	local tc=sg:GetFirst()
	while tc do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		Duel.Equip(tp,tc,c)
		tc=sg:GetNext()
	end
end
function c100427005.pncon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c100427005.cfilter(c,ec)
	return c:IsType(TYPE_SPELL+TYPE_EQUIP) and c:IsControler(tp) and c:IsAbleToGraveAsCost()
end
function c100427005.pncost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetEquipGroup():IsExists(c100427005.cfilter,1,nil,e:GetHandlerPlayer()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=c:GetEquipGroup():FilterSelect(tp,c100427005.cfilter,1,1,nil,e:GetHandlerPlayer())
	Duel.SendtoGrave(g,REASON_COST)
end
function c100427005.pnfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c100427005.pntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c100427005.pnfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100427005.pnfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c100427005.pnfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c100427005.pnop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc:IsFaceup() and tc:IsRelateToEffect(e)) then return end
	local b1=tc:IsCanChangePosition()
	local b2=aux.NegateMonsterFilter(tc)
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(100427005,0),aux.Stringid(100427005,1))
	end
	if b1 then op=0 end
	if b2 then op=1 end
	if op==0 then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	else
		if not tc:IsDisabled() and not tc:IsImmuneToEffect(e) then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			tc:RegisterEffect(e2)
		end
	end
end