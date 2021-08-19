--Beetrooper Armor Horn
--coded by Lyris
function c101105088.initial_effect(c)
	c:EnableReviveLimit()
	--mat=2 Insect monsters
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_INSECT),2,2)
	--You cannot Special Summon monsters, except Insect monsters.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(aux.TargetBoolFunction(aux.NOT(Card.IsRace),RACE_INSECT))
	c:RegisterEffect(e1)
	--You can only use each of the following effects of "Beetrooper Armor Horn" once per turn.
	--During your Main Phase, you can: Immediately after this effect resolves, Normal Summon 1 Insect monster.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101105088)
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetTarget(c101105088.target)
	e2:SetOperation(c101105088.operation)
	c:RegisterEffect(e2)
	--If this card is in your GY: You can banish 3 other Insect monsters from your GY; Special Summon this card, but banish it when it leaves the field.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,101105188)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCost(c101105088.cost)
	e3:SetTarget(c101105088.tg)
	e3:SetOperation(c101105088.op)
	c:RegisterEffect(e3)
end
function c101105088.filter(c)
	return c:IsRace(RACE_INSECT) and c:IsSummonable(true,nil)
end
function c101105088.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101105088.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c101105088.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,c101105088.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil):GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function c101105088.cfilter(c)
	return c:IsRace(RACE_INSECT) and c:IsAbleToRemoveAsCost()
end
function c101105088.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c101105088.cfilter,tp,LOCATION_GRAVE,0,3,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101105088.cfilter,tp,LOCATION_GRAVE,0,3,3,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101105088.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c101105088.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
