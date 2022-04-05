--赤しゃりの軍貫
--
--Script by Trishula9
function c101109026.initial_effect(c)
	--change name
	aux.EnableChangeCode(c,24639891,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE+LOCATION_GRAVE)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101109026)
	e1:SetCost(c101109026.spcost)
	e1:SetTarget(c101109026.sptg)
	e1:SetOperation(c101109026.spop)
	c:RegisterEffect(e1)
end
function c101109026.cfilter(c)
	return c:IsCode(24639891) and not c:IsPublic()
end
function c101109026.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101109026.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c101109026.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c101109026.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101109026.filter(c,e,tp,oc)
	return c:IsSetCard(0x166) and not c:IsCode(24639891) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c101109026.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,oc,c)
end
function c101109026.xyzfilter(c,oc,mc)
	return aux.IsCodeListed(c,mc:GetCode()) and c:IsXyzSummonable(Group.FromCards(oc,mc),2,2)
end
function c101109026.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c101109026.filter,tp,LOCATION_DECK,0,nil,e,tp,c)
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.IsPlayerCanSpecialSummonCount(tp,3)
		and mg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101109026,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=mg:Select(tp,1,1,nil)
		local sc=sg:GetFirst()
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		sc:RegisterEffect(e2)
		Duel.RaiseEvent(e:GetHandler(),EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
		local g=Group.FromCards(c,sc)
		if g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<2 then return end
		local xyzg=Duel.GetMatchingGroup(c101109026.xyzfilter,tp,LOCATION_EXTRA,0,nil,c,sc)
		if xyzg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
			Duel.XyzSummon(tp,xyz,g)
		end
	end
end