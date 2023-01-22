--赫耀的王之烙印
--Script by 奥克斯
function c101112070.initial_effect(c)
	aux.AddCodeList(c,68468459)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,101112070)
	e1:SetTarget(c101112070.target)
	e1:SetOperation(c101112070.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101112070,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1,101112070)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c101112070.thtg)
	e2:SetOperation(c101112070.thop)
	c:RegisterEffect(e2)
	if not c101112070.global_check then
		c101112070.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c101112070.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c101112070.checkfilter(c,tp)
	return c:IsType(TYPE_FUSION) and c:IsControler(tp)
end
function c101112070.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c101112070.checkfilter,1,nil,0) then Duel.RegisterFlagEffect(0,101112070,RESET_PHASE+PHASE_END,0,1) end
	if eg:IsExists(c101112070.checkfilter,1,nil,1) then Duel.RegisterFlagEffect(1,101112070,RESET_PHASE+PHASE_END,0,1) end  
end
function c101112070.filter(c,e,tp)
	local chkg=Group.FromCards(e:GetHandler(),c)
	return c:IsType(TYPE_FUSION) and aux.IsMaterialListCode(c,68468459) and c:IsFaceup() and Duel.GetMatchingGroupCount(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,chkg)>0
end
function c101112070.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c101112070.filter,tp,LOCATION_MZONE,0,nil,e,tp)
	local chkg=Group.FromCards(e:GetHandler(),g:GetFirst())
	local dg=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,chkg)
	Debug.Message(#dg) 
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,dg,#dg,0,0)
end
function c101112070.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c101112070.filter,tp,LOCATION_MZONE,0,nil,e,tp)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tag=g:Select(tp,1,1,nil)
	if #tag==0 then return end
	Duel.HintSelection(tag)
	local tcc=tag:GetFirst()
	local chkg=Group.FromCards(c,tcc)
	local dg=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,chkg)
	for tc in aux.Next(dg) do  
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
end
function c101112070.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFlagEffect(tp,101112070)
	if chk==0 then return ct>0 and e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c101112070.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end