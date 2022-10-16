--狂惑の落とし穴
--Script by 奥克斯
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if Duel.GetFlagEffect(tc:GetSummonPlayer(),id)==0 then
			Duel.RegisterFlagEffect(tc:GetSummonPlayer(),id,RESET_PHASE+PHASE_END,0,1)
		end
		if Duel.GetFlagEffect(0,id)>0 and Duel.GetFlagEffect(1,id)>0 then
			break
		end
		tc=eg:GetNext()
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1-tp,id)>0
end
function s.filter(c)
	return c:IsFaceup() and c:IsAttackAbove(2000)
end
function s.cfilter(c)
	return c:GetType()==TYPE_TRAP and c:IsSetCard(0x4c,0x89)
end
function s.rmfilter(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc)and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
	local g=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e)
		and Duel.Destroy(tc,REASON_EFFECT)>0 then
		local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_GRAVE,0,nil)
		local rg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.rmfilter),tp,0,LOCATION_GRAVE,nil)
		if #g>0 and #rg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local mg=rg:Select(tp,1,1,nil)
			Duel.Remove(mg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
