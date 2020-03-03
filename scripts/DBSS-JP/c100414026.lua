--六花の薄氷

--Scripted by mallu11
function c100414026.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100414026,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,100414026+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c100414026.cost)
	e1:SetTarget(c100414026.target)
	e1:SetOperation(c100414026.activate)
	c:RegisterEffect(e1)
end
function c100414026.filter(c,check)
	return c:IsFaceup() and (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT) and (check or c:IsControlerCanBeChanged())
end
function c100414026.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c100414026.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingTarget(c100414026.filter,1-tp,LOCATION_MZONE,0,1,nil,true)
	local b2=Duel.IsExistingTarget(c100414026.filter,1-tp,LOCATION_MZONE,0,1,nil) and Duel.CheckReleaseGroup(tp,Card.IsRace,1,nil,RACE_PLANT)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return b1 or b2
	end
	if b2 and (not b1 or Duel.SelectOption(tp,aux.Stringid(100414026,1),aux.Stringid(100414026,2))==1) then
		e:SetCategory(CATEGORY_CONTROL)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectReleaseGroup(tp,Card.IsRace,1,1,nil,RACE_PLANT)
		Duel.Release(g,REASON_COST)
		Duel.SetTargetParam(1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectTarget(tp,c100414026.filter,1-tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
	else
		e:SetCategory(0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectTarget(tp,c100414026.filter,1-tp,LOCATION_MZONE,0,1,1,nil,true)
	end
	e:SetLabel(0)
end
function c100414026.activate(e,tp,eg,ep,ev,re,r,rp)
	local param=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local check=nil
	if param==1 then
		check=false
	else
		check=true
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		if not check and tc:IsControlerCanBeChanged() then
			Duel.BreakEffect()
			if Duel.GetControl(tc,tp,PHASE_END,1)~=0 then
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_CHANGE_RACE)
				e2:SetValue(RACE_PLANT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
		end
	end
end
