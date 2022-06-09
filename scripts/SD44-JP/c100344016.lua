--Awakening of the Crystal Lord
local s,id,o=GetID()
function s.initial_effect(c)
	--If you control an "Ultimate Crystal" monster: Activate 1 or both of the following effects, OR: Reveal 1 "Ultimate Crystal" monster in your hand and activate 1 of the following effects;(below) You can only activate 1 "Awakening of the Crystal Lord" per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetLabel(0)
	e1:SetCondition(s.con)
	e1:SetCost(function() e1:SetLabel(100) return true end)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsSetCard),tp,LOCATION_MZONE,0,1,nil,0x2034)
		or Duel.IsExistingMatchingCard(aux.AND(Card.IsSetCard,aux.NOT(Card.IsPublic)),tp,LOCATION_HAND,0,1,nil,0x2034)
end
function s.hfilter(c)
	return c:IsCode(63945693,5611760,40854824) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function s.sfilter(c,e,tp)
	return c:GetOriginalType()&TYPE_MONSTER>0 and c:IsSetCard(0x1034)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.hfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_SZONE,0,1,nil,e,tp)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
	return s.con(e,tp,eg,ep,ev,re,r,rp) and (b1 or b2) end
	local rg=Duel.GetMatchingGroup(aux.AND(Card.IsSetCard,aux.NOT(Card.IsPublic)),tp,LOCATION_HAND,0,nil,0x2034)
	local con=Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsSetCard),tp,LOCATION_MZONE,0,1,nil,0x2034)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local res=rg:SelectSubGroup(tp,aux.TRUE,con,1,1)
	if rg then Duel.ConfirmCards(1-tp,rg)
	Duel.ShuffleHand(tp) end
	local op=0
	if b1 and b2 then
		if res then op=Duel.SelectOption(tp,1190,1152)
		else op=Duel.SelectOption(tp,1190,1152,aux.Stringid(id,0))) end
	elseif b1 then op=Duel.SelectOption(tp,1190)
	else op=Duel.SelectOption(tp,1152)+1 end
	e:SetLabel(op)
	if op~=0 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
		if op~=1 then
			e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
			Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
			Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
		else e:SetCategory(CATEGORY_SPECIAL_SUMMON) end
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local res=0
	--Take 1 "Bridge" card or 1 "Rainbow Refraction" from your Deck, and either add it to your hand or send it to the GY.
	if op~=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,s.hfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if tc and tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
			res=Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			res=Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
	--Special Summon 1 "Crystal Beast" Monster Card from your hand, Deck, GY, or Spell & Trap Zone.
	if op~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.sfilter),tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_SZONE,0,1,1,nil,e,tp)
		if #g>0 and op==2 and res~=0 then Duel.BreakEffect() end
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
