--リターン・オブ・アンデット
--Return of Zombie
--Scripted by Eerie Code
function c100307034.initial_effect(c)
	--banish and summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100307034)
	e1:SetTarget(c100307034.target)
	e1:SetOperation(c100307034.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetDescription(aux.Stringid(35498188,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100307034+100)
	e2:SetTarget(c100307034.settg)
	e2:SetOperation(c100307034.setop)
	c:RegisterEffect(e2)
end
function c100307034.rmfilter(c,e,tp)
	local p=c:GetControler()
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and c:IsAbleToRemove()
		and Duel.GetMZoneCount(p,c,p,LOCATION_REASON_TOFIELD)
		and Duel.IsExistingMatchingCard(c100307034.spfilter,p,LOCATION_GRAVE,0,1,nil,e,tp,p)
end
function c100307034.spfilter(c,e,tp,p)
	return c:IsRace(RACE_ZOMBIE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,p)
end
function c100307034.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100307034.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,PLAYER_ALL,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,PLAYER_ALL,LOCATION_GRAVE)
end
function c100307034.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rc=Duel.SelectMatchingCard(tp,c100307034.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp):GetFirst()
	if rc and Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)~=0 then
		local p=rc:GetPreviousControler()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100307034.spfilter),p,LOCATION_GRAVE,0,1,1,nil,e,tp,p)
		if #g>0 then Duel.SpecialSummon(g,0,tp,p,false,false,POS_FACEUP_DEFENSE) end
	end
end
function c100307034.setfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and c:IsAbleToDeck()
end
function c100307034.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable()
		and Duel.IsExistingMatchingCard(c100307034.setfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c100307034.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c100307034.setfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if #g>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0
		and c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end
