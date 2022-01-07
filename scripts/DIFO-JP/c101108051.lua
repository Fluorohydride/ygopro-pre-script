--森羅の舞踏娘 ピオネ

--Script by Chrono-Genex
function c101108051.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_PLANT),2,2)
	--deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101108051,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,101108051)
	e1:SetCondition(c101108051.condition)
	e1:SetTarget(c101108051.target)
	e1:SetOperation(c101108051.operation)
	c:RegisterEffect(e1)
	--change lv
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101108051,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101108051+100)
	e2:SetTarget(c101108051.lvtg)
	e2:SetOperation(c101108051.lvop)
	c:RegisterEffect(e2)
end
function c101108051.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c101108051.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
end
function c101108051.spfilter(c,e,tp)
	return c:IsRace(RACE_PLANT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101108051.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerCanDiscardDeck(tp,3) then return end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if ct==0 then return end
	local ac=1
	if ct>1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101108051,2))
		ac=Duel.AnnounceNumber(tp,1,math.min(ct,3))
	end
	Duel.ConfirmDecktop(tp,ac)
	local g=Duel.GetDecktopGroup(tp,ac)
	local og=g:Filter(c101108051.spfilter,nil,e,tp)
	if og:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101108051,3)) then
		local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),2)
		if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=og:Select(tp,1,ft,nil)
		for tc in aux.Next(sg) do
			if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
				e1:SetValue(1)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				og:RemoveCard(tc)
			end
		end
		Duel.SpecialSummonComplete()
	end
	Duel.DisableShuffleCheck()
	Duel.SendtoGrave(og,REASON_EFFECT+REASON_REVEAL)
end
function c101108051.lvfilter1(c)
	return c:IsRace(RACE_PLANT) and c:IsLevelAbove(1)
end
function c101108051.lvfilter2(c,g)
	return c:IsFaceup() and g:IsContains(c)
end
function c101108051.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lg=c:GetLinkedGroup()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101108051.lvfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101108051.lvfilter1,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c101108051.lvfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,0,1,nil,lg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101108051.lvfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c101108051.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local lg=c:GetLinkedGroup()
	local g=Duel.GetMatchingGroup(c101108051.lvfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,lg)
	local lv=tc:GetLevel()
	for lc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		lc:RegisterEffect(e1)
	end
end
