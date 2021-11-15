--不朽の七皇
--
--Script by Trishula9
function c100426007.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--choose
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,100426007)
	e2:SetTarget(c100426007.target)
	e2:SetOperation(c100426007.operation)
	c:RegisterEffect(e2)
end
function c100426007.filter(c)
	local m=_G["c"..c:GetCode()]
	if not m then return false end
	local no=m.xyz_number
	return no and no>=101 and no<=107
end
function c100426007.cfilter(c)
	if not c:IsType(TYPE_XYZ) then return false end
	if c100426007.filter(c) then return true end
	local g=c:GetOverlayGroup()
	return g:IsExists(c100426007.filter,1,nil)
end
function c100426007.disfilter(c,atk)
	return aux.NegateMonsterFilter(c) and c:IsAttackBelow(atk)
end
function c100426007.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100426007.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100426007.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c100426007.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	local s=0
	local b1=Duel.IsExistingMatchingCard(c100426007.disfilter,tp,0,LOCATION_MZONE,1,nil,tc:GetAttack())
	local b2=tc:GetOverlayGroup():GetCount()>0
	if b1 and not b2 then
		s=Duel.SelectOption(tp,aux.Stringid(100426007,0))
	end
	if not b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(100426007,1))+1
	end
	if b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(100426007,0),aux.Stringid(100426007,1))
	end
	e:SetLabel(s)
end
function c100426007.operation(e,tp,eg,ep,ev,re,r,rp)
	local s=e:GetLabel()
	local tc=Duel.GetFirstTarget()
	if s==0 then
		local sg=Duel.GetMatchingGroup(c100426007.disfilter,tp,0,LOCATION_MZONE,nil,tc:GetAttack())
		if sg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
			local sc=sg:Select(tp,1,1,nil):GetFirst()
			if sc and not sc:IsImmuneToEffect(e) then
				Duel.NegateRelatedChain(sc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				sc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				sc:RegisterEffect(e2)
			end
		end
	end
	if s==1 then
		if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
			local og=tc:GetOverlayGroup()
			if og:GetCount()>0 and Duel.SendtoGrave(og,REASON_EFFECT)>0
				and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.IsExistingMatchingCard(c100426007.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
				and Duel.SelectYesNo(tp,aux.Stringid(100426007,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local ng=Duel.SelectMatchingCard(tp,c100426007.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
				if ng:GetCount()>0 then
					Duel.SpecialSummon(ng,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end
function c100426007.spfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x48) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
