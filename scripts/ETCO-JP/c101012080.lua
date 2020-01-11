--ピンポイント奪取

--Scripted by mallu11
function c101012080.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,101012080+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101012080.target)
	e1:SetOperation(c101012080.activate)
	c:RegisterEffect(e1)
end
function c101012080.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)>0
		and Duel.GetMatchingGroupCount(Card.IsFacedown,tp,0,LOCATION_EXTRA,nil)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_EXTRA)
end
function c101012080.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_EXTRA,nil)
	if g1:GetCount()<=0 or g2:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local tc1=g1:Select(tp,1,1,nil):GetFirst()
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SELECT)
	local tc2=g2:Select(1-tp,1,1,nil):GetFirst()
	local tg=Group.FromCards(tc1,tc2)
	Duel.ConfirmCards(tp,tg)
	local res=false
	for i,type in ipairs({TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ,TYPE_LINK}) do
		if tc1:IsType(type) and tc2:IsType(type) then
			res=true
			break
		end
	end
	if res then
		if tc1:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			if Duel.GetLocationCountFromEx(tp,tp,nil,tc1)>0 then
				Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP)
			end
		end
		Duel.SendtoGrave(tc2,REASON_EFFECT)
		if tc1:GetOriginalRace()==tc2:GetOriginalRace() and tc1:GetOriginalAttribute()==tc2:GetOriginalAttribute() then
			local atk=tc2:GetTextAttack()
			Duel.SetLP(1-tp,Duel.GetLP(1-tp)-atk)
		end
	else
		Duel.SendtoGrave(tc1,REASON_EFFECT)
		if tc2:IsCanBeSpecialSummoned(e,0,1-tp,false,false,POS_FACEUP,1-tp) then
			if Duel.GetLocationCountFromEx(1-tp,1-tp,nil,tc2)>0 then
				Duel.SpecialSummon(tc2,0,1-tp,1-tp,false,false,POS_FACEUP)
			end
		end
	end
end
