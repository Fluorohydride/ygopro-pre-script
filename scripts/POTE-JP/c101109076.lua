--エクソシスター・リタニア

--Scripted by mallu11
function c101109076.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,101109076+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101109076.condition)
	e1:SetCost(c101109076.cost)
	e1:SetTarget(c101109076.target)
	e1:SetOperation(c101109076.activate)
	c:RegisterEffect(e1)
	if not c101109076.global_check then
		c101109076.global_check=true
		local ge1=Effect.GlobalEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetCondition(c101109076.checkcon)
		ge1:SetOperation(c101109076.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c101109076.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_XYZ)
end
function c101109076.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsSummonType,nil,SUMMON_TYPE_XYZ)
	local tc=g:GetFirst()
	while tc do
		if Duel.GetFlagEffect(tc:GetSummonPlayer(),101109076)==0 then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),101109076,RESET_PHASE+PHASE_END,0,1)
		end
		if Duel.GetFlagEffect(0,101109076)>0 and Duel.GetFlagEffect(1,101109076)>0 then
			break
		end
		tc=g:GetNext()
	end
end
function c101109076.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x172)
end
function c101109076.condition(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	return ct>0 and ct==Duel.GetMatchingGroupCount(c101109076.cfilter,tp,LOCATION_MZONE,0,nil)
end
function c101109076.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c101109076.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c101109076.xyzfilter(c)
	return c:IsSetCard(0x172) and c:IsXyzSummonable(nil)
end
function c101109076.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		local b1=Duel.IsExistingMatchingCard(c101109076.xyzfilter,tp,LOCATION_EXTRA,0,1,nil)
		local b2=Duel.GetFlagEffect(tp,101109076)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
		if not b1 and not b2 then return end
		local off=1
		local ops={}
		local opval={}
		if b1 then
			ops[off]=aux.Stringid(101109076,0)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(101109076,1)
			opval[off-1]=2
			off=off+1
		end
		ops[off]=aux.Stringid(101109076,2)
		opval[off-1]=3
		off=off+1
		local op=Duel.SelectOption(tp,table.unpack(ops))
		if opval[op]==1 then
			Duel.BreakEffect()
			local g=Duel.GetMatchingGroup(c101109076.xyzfilter,tp,LOCATION_EXTRA,0,nil)
			if g:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=g:Select(tp,1,1,nil)
				Duel.XyzSummon(tp,tg:GetFirst(),nil)
			end
		elseif opval[op]==2 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(g)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end
