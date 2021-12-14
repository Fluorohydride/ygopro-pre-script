--ホーンテッド・アンデット
--
--Script by Trishula9
function c101108076.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101108076,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101108076)
	e1:SetTarget(c101108076.target)
	e1:SetOperation(c101108076.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101108076,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101108076)
	e2:SetTarget(c101108076.settg)
	e2:SetOperation(c101108076.setop)
	c:RegisterEffect(e2)
end
function c101108076.rmfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsLevelAbove(1) and c:IsAbleToRemove()
		and Duel.IsPlayerCanSpecialSummonMonster(tp,101108176,nil,TYPES_TOKEN_MONSTER,0,0,c:GetLevel(),RACE_ZOMBIE,ATTRIBUTE_DARK)
end
function c101108076.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c101108076.rmfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,PLAYER_ALL,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
end
function c101108076.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,c101108076.rmfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil):GetFirst()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_REMOVED)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,101108176,nil,TYPES_TOKEN_MONSTER,0,0,tc:GetLevel(),RACE_ZOMBIE,ATTRIBUTE_DARK) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,101108176)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(tc:GetLevel())
			token:RegisterEffect(e1)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c101108076.setfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and c:IsAbleToDeck()
end
function c101108076.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable()
		and Duel.IsExistingMatchingCard(c101108076.setfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c101108076.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c101108076.setfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if #g>0 and Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0
		and c:IsRelateToEffect(e) and Duel.SSet(tp,c)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end