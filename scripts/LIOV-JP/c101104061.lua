--ユウ－Ai－
--You & A.I.
--Scripted by Kohana Sonogami
function c101104061.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--EARTH or WATER
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101104061,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,101104061)
	e2:SetCondition(c101104061.attrcon1)
	e2:SetTarget(c101104061.attrtg1)
	e2:SetOperation(c101104061.attrop1)
	c:RegisterEffect(e2)
	--WIND or LIGHT
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101104061,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,101104061+100)
	e3:SetCondition(c101104061.attrcon2)
	e3:SetTarget(c101104061.attrtg2)
	e3:SetOperation(c101104061.attrop2)
	c:RegisterEffect(e3)
	--FIRE or DARK
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101104061,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,101104061+200)
	e4:SetCondition(c101104061.attrcon3)
	e4:SetTarget(c101104061.attrtg3)
	e4:SetOperation(c101104061.attrop3)
	c:RegisterEffect(e4)
end
function c101104061.filter(c,att)
	return c:GetBaseAttack()==2300 and c:IsRace(RACE_CYBERSE) and c:IsAttribute(att)
end
function c101104061.attrcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101104061.filter,1,nil,ATTRIBUTE_EARTH+ATTRIBUTE_WATER)
end
function c101104061.attrtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.nzatk,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c101104061.attrop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,aux.nzatk,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if #g==0 then return end
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(math.ceil(tc:GetAttack()/2))
	tc:RegisterEffect(e1)
end
function c101104061.attrcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101104061.filter,1,nil,ATTRIBUTE_WIND+ATTRIBUTE_LIGHT)
end
function c101104061.attrtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c101104061.attrop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectMatchingCard(tp,aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g==0 then return end
	Duel.HintSelection(g)
	local tc=g:GetFirst()
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
end
function c101104061.attrcon3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101104061.filter,1,nil,ATTRIBUTE_FIRE+ATTRIBUTE_DARK)
end
function c101104061.attrtg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,11738490,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end
function c101104061.attrop3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,11738490,0,0x4011,0,0,1,RACE_CYBERSE,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,101104161)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
