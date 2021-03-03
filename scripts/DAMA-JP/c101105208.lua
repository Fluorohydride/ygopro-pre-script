--セイヴァー・ミラージュ

--scripted by Xylen5967 & mercury233
function c101105208.initial_effect(c)
	aux.AddCodeList(c,44508094)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--apply
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c101105208.condition)
	e2:SetTarget(c101105208.target)
	e2:SetOperation(c101105208.activate)
	c:RegisterEffect(e2)
end
function c101105208.cfilter(c,tp,rp)
	return c:IsPreviousControler(tp) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD)
		and (c:IsCode(44508094) or c:GetPreviousTypeOnField()&TYPE_SYNCHRO~=0 and aux.IsCodeListed(c,44508094))
		and c:IsReason(REASON_COST+REASON_EFFECT) and rp==tp
end
function c101105208.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101105208.cfilter,1,nil,tp,rp)
end
function c101105208.spfilter(c,e,tp)
	if not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return false end
	if c:IsFaceup() and c:IsLocation(LOCATION_EXTRA) then
		return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
	end
	if c:IsLocation(LOCATION_GRAVE) or c:IsFaceup() and c:IsLocation(LOCATION_REMOVED) then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	return false
end
function c101105208.rfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c101105208.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local b1=eg:Filter(c101105208.cfilter,nil,tp,rp):IsExists(c101105208.spfilter,1,nil,e,tp) and Duel.GetFlagEffect(tp,101105208)==0
		local b2=Duel.IsExistingMatchingCard(c101105208.rfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) and Duel.GetFlagEffect(tp,101105208+100)==0
		local b3=Duel.GetFlagEffect(tp,101105208+200)==0
		return b1 or b2 or b3
	end
end
function c101105208.activate(e,tp,eg,ep,ev,re,r,rp)
	local b1=eg:Filter(c101105208.cfilter,nil,tp,rp):IsExists(c101105208.spfilter,1,nil,e,tp) and Duel.GetFlagEffect(tp,101105208)==0
	local b2=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c101105208.rfilter),tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) and Duel.GetFlagEffect(tp,101105208+100)==0
	local b3=Duel.GetFlagEffect(tp,101105208+200)==0
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(101105208,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(101105208,1)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(101105208,2)
		opval[off-1]=3
		off=off+1
	end
	if off==1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		local sg=eg:Filter(c101105208.cfilter,nil,tp,rp):Filter(c101105208.spfilter,nil,e,tp)
		if #sg>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sg=sg:Select(tp,1,1,nil)
		end
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		Duel.RegisterFlagEffect(tp,101105208,RESET_PHASE+PHASE_END,0,1)
	elseif opval[op]==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101105208.rfilter),tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
		Duel.HintSelection(rg)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,101105208+100,RESET_PHASE+PHASE_END,0,1)
	else
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(c101105208.damval)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,101105208+200,RESET_PHASE+PHASE_END,0,1)
	end
end
function c101105208.damval(e,re,val,r,rp,rc)
	return math.floor(val/2)
end
