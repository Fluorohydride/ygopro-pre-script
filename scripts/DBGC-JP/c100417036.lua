--coded by Lyris
--Resurrection Breath
function c100417036.initial_effect(c)
	--If you control "Brave Token": Special Summon up to 2 monsters with different names from your hand and/or GY (but banish them when they leave the field), then you can equip 1 Equip Spell that specifically lists "Brave Token" in its text from your hand or GY to 1 appropriate monster you control. You can only activate 1 "Resurrection Breath" per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100417036+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(function(e,tp) return Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsCode),tp,LOCATION_ONFIELD,0,1,nil,100417125) end)
	e1:SetTarget(c100417036.target)
	e1:SetOperation(c100417036.activate)
	c:RegisterEffect(e1)
end
function c100417036.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c100417036.filter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c100417036.eqfilter),tp,LOCATION_DECK,0,1,nil,tp,c)
end
function c100417036.eqfilter(c,tp,tc)
	return c:CheckUniqueOnField(tp) and not c:IsForbidden() and c:CheckEquipTarget(tc) and aux.IsCodeListed(c,CARD_BRAVE_TOKEN)
end
function c100417036.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local ft=math.min(2,Duel.GetLocationCount(tp,LOCATION_MZONE))
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsCanBeSpecialSummoned),tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,e,0,tp,false,false):SelectSubGroup(tp,aux.dncheck,false,1,ft)
	local ct=0
	for tc in aux.Next(g1) do if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		e1:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e1,true)
		ct=ct+1
	end end
	Duel.SpecialSummonComplete()
	if ct==0 then return end
	local g2=Duel.GetMatchingGroup(c100417036.filter,tp,LOCATION_MZONE,0,1,nil,tp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and #g2>0 and Duel.SelectEffectYesNo(tp,c) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sc=g2:Select(tp,1,1,nil):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		Duel.Equip(tp,Duel.SelectMatchingCard(aux.NecroValleyFilter(c100417036.eqfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp,sc):GetFirst(),sc)
	end
end
