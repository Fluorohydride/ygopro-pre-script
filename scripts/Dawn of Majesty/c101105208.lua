--セイヴァー・ミラージュ

--scripted by Xylen5967
function c101105208.initial_effect(c)
	aux.AddCodeList(c,44508094)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--apply
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCondition(c101105208.condition)
	e2:SetTarget(c101105208.target)
	e2:SetOperation(c101105208.activate)
	c:RegisterEffect(e2)
end
function c101105208.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101105208.spfilter,1,nil,r,re,tp)
end
function c101105208.spfilter(c,r,re,tp)
	return c:GetPreviousControler()==tp and (c:IsCode(44508094) or c:IsType(TYPE_SYNCHRO) and aux.IsCodeListed(c,44508094))
		and c==re:GetHandler() and c:IsPreviousLocation(LOCATION_MZONE) and c:IsReason(REASON_EFFECT+REASON_COST)
end
function c101105208.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=nil
	local c=e:GetHandler()
	local sg=eg:Filter(c101105208.spfilter,nil,r,re,tp):IsExists(Card.IsCanBeSpecialSummoned,1,nil,e,0,tp,false,false)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and sg and Duel.GetFlagEffect(tp,101105208)==0
	local b2=Duel.IsExistingMatchingCard(c101105208.rfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) and Duel.GetFlagEffect(tp,101105208)==0
	local b3=Duel.GetFlagEffect(tp,101105208)==0
	if chk==0 then
		return c:GetFlagEffect(101105208)==0 and (b1 or b2 or b3)
	end
	c:RegisterFlagEffect(101105208,RESET_CHAIN,0,1)
end
function c101105208.rfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c101105208.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=nil
	local sg=eg:Filter(c101105208.spfilter,nil,r,re,tp):IsExists(Card.IsCanBeSpecialSummoned,1,nil,e,0,tp,false,false)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and sg and Duel.GetFlagEffect(tp,101105208)==0
	local b2=Duel.IsExistingMatchingCard(c101105208.rfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) and Duel.GetFlagEffect(tp,101105208)==0
	local b3=Duel.GetFlagEffect(tp,101105208)==0
	if b1 and b2 and b3 then op=Duel.SelectOption(tp,aux.Stringid(101105208,0),aux.Stringid(101105208,1),aux.Stringid(101105208,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(101105208,0)) --Special Summon 1 of those monsters
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(101105208,1))+1 --Banish 1 monster your opponent controls or in their GY
	elseif b3 then op=Duel.SelectOption(tp,aux.Stringid(101105208,2))+2 --All damage you take this turn is halved.
	else return end
	if op==0 then
		local sg=eg:Filter(c101105208.spfilter,nil,r,re,tp):FilterSelect(tp,Card.IsCanBeSpecialSummoned,1,1,nil,e,0,tp,false,false)
		if #sg==0 then return end
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		Duel.RegisterFlagEffect(tp,101105208,RESET_PHASE+PHASE_END,0,1)
	elseif op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,c101105208.rfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
		if #rg==0 then return end
		Duel.HintSelection(rg)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,101105208,RESET_PHASE+PHASE_END,0,1)
	else
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(c101105208.val)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,101105208,RESET_PHASE+PHASE_END,0,1)
	end
end
function c101105208.val(e,re,dam,r,rp,rc)
	if c101105208[e:GetOwnerPlayer()]==1 or bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 then
		return math.floor(dam/2)
	else return dam end
end
