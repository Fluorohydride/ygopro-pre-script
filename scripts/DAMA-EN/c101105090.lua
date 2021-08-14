--coded by Lyris
--Beetrooper Formation
function c101105090.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--You can only use each effect of "Beetrooper Formation" once per turn.
	--You can target 1 "Beetrooper" monster in your GY; Special Summon it, but it cannot attack this turn, also you lose LP equal to its original ATK.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,101105090)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetTarget(c101105090.target)
	e1:SetOperation(c101105090.operation)
	c:RegisterEffect(e1)
	--If a face-up Insect monster(s) you control is destroyed by battle or card effect: You can Special Summon 1 "Beetrooper Token" (Insect/EARTH/Level 3/ATK 1000/DEF 1000).
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,101105190)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetCondition(c101105090.condition)
	e2:SetTarget(c101105090.tg)
	e2:SetOperation(c101105090.op)
	c:RegisterEffect(e2)
end
function c101105090.filter(c,e,tp)
	return c:IsSetCard(0x270) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101105090.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101105090.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101105090.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101105090.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101105090.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_ATTACK)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3,true)
		Duel.SetLP(tp,Duel.GetLP(tp)-tc:GetBaseAttack())
	end
	Duel.SpecialSummonComplete()
end
function c101105090.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp) and c:IsRace(RACE_INSECT)
end
function c101105090.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101105090.cfilter,1,nil,tp)
end
function c101105090.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,101105190,0x270,TYPES_TOKEN_MONSTER,1000,1000,3,RACE_INSECT,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c101105090.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,101105190,0x270,TYPES_TOKEN_MONSTER,1000,1000,3,RACE_INSECT,ATTRIBUTE_EARTH) then return end
	local tk=Duel.CreateToken(tp,101105190)
	Duel.SpecialSummon(tk,0,tp,tp,false,false,POS_FACEUP)
end
