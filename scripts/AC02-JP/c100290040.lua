--Gゴーレム・ロックハンマー
--LUA BY AKAWAKU
function c100290040.initial_effect(c)
	--level down
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100290040,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100290040)
	e1:SetCost(c100290040.lvcost)
	e1:SetOperation(c100290040.lvop)
	c:RegisterEffect(e1)	
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100290040,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100290140)
	e2:SetCost(c100290040.tkcost)
	e2:SetTarget(c100290040.tktg)
	e2:SetOperation(c100290040.tkop)
	c:RegisterEffect(e2)
end
function c100290040.lvcfilter(c)
	return c:IsRace(RACE_CYBERSE) and c:IsAbleToGraveAsCost()
end
function c100290040.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100290040.lvcfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,c100290040.lvcfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c100290040.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c100290040.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c100290040.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>2
		and Duel.IsPlayerCanSpecialSummonMonster(tp,100290140,0x285,TYPES_TOKEN_MONSTER,0,0,3,RACE_CYBERSE,ATTRIBUTE_EARTH,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,3,0,0)
end
function c100290040.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>2 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,100290140,0x285,TYPES_TOKEN_MONSTER,0,0,3,RACE_CYBERSE,ATTRIBUTE_EARTH,POS_FACEUP_DEFENSE) then
		local ct=3
		while ct>0 do
			local token=Duel.CreateToken(tp,100290140)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			ct=ct-1
		end
		Duel.SpecialSummonComplete()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c100290040.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c100290040.splimit(e,c)
	return not c:IsRace(RACE_CYBERSE)
end