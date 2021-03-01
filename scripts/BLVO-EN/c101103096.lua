--War Rock Skyler
--Scripted by Kohana Sonogami
function c101103096.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c101103096.val)
	c:RegisterEffect(e1)
	--special summon & atkchange
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101103096,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,101103096)
	e2:SetCondition(c101103096.spcon)
	e2:SetTarget(c101103096.sptg)
	e2:SetOperation(c101103096.spop)
	c:RegisterEffect(e2)
	if not c101103096.global_check then
		c101103096.global_check=true
		local ge1=Effect.GlobalEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLED)
		ge1:SetOperation(c101103096.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c101103096.check(c)
	return c and c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c101103096.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c0,c1=Duel.GetBattleMonster(0)
	if c101103096.check(c0) then
		Duel.RegisterFlagEffect(0,101103096,RESET_PHASE+PHASE_END,0,1)
	end
	if c101103096.check(c1) then
		Duel.RegisterFlagEffect(1,101103096,RESET_PHASE+PHASE_END,0,1)
	end
end
function c101103096.val(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)*100
end
function c101103096.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,101103096)>0
		and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c101103096.spfilter(c,e,tp)
	return c:IsLevelAbove(5) and c:IsRace(RACE_WARRIOR) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101103096.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101103096.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101103096.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101103096.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101103096.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x15f)
end
function c101103096.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	local g=Duel.GetMatchingGroup(c101103096.atkfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e1:SetValue(200)
		tc:RegisterEffect(e1)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsLevelBelow,5))
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
