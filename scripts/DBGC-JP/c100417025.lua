--アラメシアの儀
--
--Script by IceBarrierTrishula
function c100417025.initial_effect(c)
	aux.AddCodeList(c,100417125)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100417025+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100417025.condition)
	e1:SetCost(c100417025.cost)
	e1:SetTarget(c100417025.target)
	e1:SetOperation(c100417025.operation)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(100417025,ACTIVITY_CHAIN,c100417025.chainfilter)
end
function c100417025.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	return not (re:IsActiveType(TYPE_MONSTER) and rc:IsLocation(LOCATION_MZONE) and not rc:IsSummonType(SUMMON_TYPE_SPECIAL))
end
function c100417025.cfilter0(c)
	return c:IsCode(100417125) and c:IsFaceup()
end
function c100417025.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c100417025.cfilter0,tp,LOCATION_ONFIELD,0,1,nil)
end
function c100417025.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(100417025,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetValue(c100417025.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c100417025.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not rc:IsSummonType(SUMMON_TYPE_SPECIAL) and rc:IsLocation(LOCATION_MZONE)
end
function c100417025.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		Duel.IsPlayerCanSpecialSummonMonster(tp,100417125,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FAIRY,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c100417025.cfilter(c)
	return c:IsCode(100417029) and c:IsFaceup()
end
function c100417025.setfilter(c)
	return c:IsCode(100417029) and not c:IsForbidden()
end
function c100417025.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,100417125,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FAIRY,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,100417125)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	local g=Duel.GetMatchingGroup(c100417025.setfilter,tp,LOCATION_DECK,0,nil)
	if not Duel.IsExistingMatchingCard(c100417025.cfilter,tp,LOCATION_SZONE,0,1,nil) and g:GetCount()>0
		and Duel.SelectYesNo(tp,aux.Stringid(100417025,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg=g:Select(tp,1,1,nil)
		Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
