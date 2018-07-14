--通販売員
--Two-Man Salesman
--Scripted by Eerie Code
function c101006032.initial_effect(c)
	--confirm
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c101006032.target)
	e1:SetOperation(c101006032.operation)
	c:RegisterEffect(e1)
end
function c101006032.filter(c)
	return not c:IsPublic()
end
function c101006032.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(c101006032.filter,tp,LOCATION_HAND,0,nil)*Duel.GetMatchingGroupCount(c101006032.filter,tp,0,LOCATION_HAND,nil)>0 end
end
function c101006032.operation(e,tp,eg,ep,ev,re,r,rp)
	local hg1=Duel.GetMatchingGroup(c101006032.filter,tp,LOCATION_HAND,0,nil)
	local hg2=Duel.GetMatchingGroup(c101006032.filter,tp,0,LOCATION_HAND,nil)
	if #hg1==0 or #hg2==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc1=hg1:Select(tp,1,1,nil):GetFirst()
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
	local tc2=hg2:Select(1-tp,1,1,nil):GetFirst()
	local tg={tc1,tc2}
	if tc2:IsControler(0) then tc={tc2,tc1} end
	if tc1:IsType(TYPE_MONSTER) and tc2:IsType(TYPE_MONSTER) then
		for p=0,1 do
			local tc=tg[p]
			if Duel.GetLocationCount(p,LOCATION_MZONE)>0
				and tc:IsCanBeSpecialSummoned(e,0,p,false,false)
				and Duel.SelectYesNo(p,aux.Stringid(101006032,1)) then
				Duel.SpecialSummon(tc,0,p,p,false,false,POS_FACEUP)
			end
		end
	elseif tc1:IsType(TYPE_SPELL) and tc2:IsType(TYPE_SPELL)
		and Duel.IsPlayerCanDraw(tp,2) and Duel.IsPlayerCanDraw(1-tp,2) then
		Duel.Draw(tp,2,REASON_EFFECT)
		Duel.Draw(1-tp,2,REASON_EFFECT)
	elseif tc1:IsType(TYPE_TRAP) and tc2:IsType(TYPE_TRAP)
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_DECK,0,2,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_DECK,2,nil) then
		for p=0,1 do
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(p,Card.IsAbleToGrave,p,LOCATION_DECK,0,2,2,nil)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
