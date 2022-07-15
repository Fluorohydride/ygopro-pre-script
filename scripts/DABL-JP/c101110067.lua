--禁呪アラマティア
--Script by JoyJ
function c101110067.initial_effect(c)
	aux.AddCodeList(c,3285552)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,101110067)
	e2:SetCost(c101110067.tkcost)
	e2:SetTarget(c101110067.tktg)
	e2:SetOperation(c101110067.tkop)
	c:RegisterEffect(e2)
	--token if monster destroyed
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,101110067+100)
	e3:SetCondition(c101110067.spcon)
	e3:SetTarget(c101110067.sptg)
	e3:SetOperation(c101110067.spop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(101110067,ACTIVITY_SPSUMMON,c101110067.counterfilter)
end
function c101110067.counterfilter(c)
	return aux.IsCodeListed(c,3285552) or c:IsCode(3285552)
end
function c101110067.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(101110067,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101110067.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c101110067.splimit(e,c)
	return not c101110067.counterfilter(c)
end
function c101110067.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,3285552,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FAIRY,ATTRIBUTE_EARTH)
	local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,3285552,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FAIRY,ATTRIBUTE_EARTH,POS_FACEUP,1-tp)
	if chk==0 then return (b1 or b2)
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c101110067.tkop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,3285552,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FAIRY,ATTRIBUTE_EARTH)
	local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,3285552,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FAIRY,ATTRIBUTE_EARTH,POS_FACEUP,1-tp)
	local sel=0
	if b1 or b2 then
		if b1 and b2 then
			sel=Duel.SelectOption(tp,aux.Stringid(101110067,2),aux.Stringid(101110067,3))
		elseif b2 then
			sel=1
		end
		local to=tp
		if sel==1 then to=1-tp end
		local token=Duel.CreateToken(tp,101110167)
		if Duel.SpecialSummon(token,0,tp,to,false,false,POS_FACEUP)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,1,nil)
			if #g>0 then
				Duel.BreakEffect()
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
		end
	end
end
function c101110067.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp)
end
function c101110067.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101110067.cfilter,1,nil,tp)
end
function c101110067.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,3285552,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FAIRY,ATTRIBUTE_EARTH)
	local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,3285552,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FAIRY,ATTRIBUTE_EARTH,POS_FACEUP,1-tp)
	if chk==0 then return b1 or b2 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,PLAYER_ALL,0)
end
function c101110067.spop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,3285552,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FAIRY,ATTRIBUTE_EARTH)
	local b2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,3285552,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_FAIRY,ATTRIBUTE_EARTH,POS_FACEUP,1-tp)
	local sel=0
	if b1 or b2 then
		if b1 and b2 then
			sel=Duel.SelectOption(tp,aux.Stringid(101110067,2),aux.Stringid(101110067,3))
		elseif b2 then
			sel=1
		end
		local to=tp
		if sel==1 then to=1-tp end
		local token=Duel.CreateToken(tp,101110167)
		Duel.SpecialSummon(token,0,tp,to,false,false,POS_FACEUP)
	end
end