--スケアクロー・ライヒハート
--
--HanamomoHakune
function c101108012.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101108012+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101108012.hspcon)
	e1:SetValue(c101108012.hspval)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101108012,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,101108012+100)
	e2:SetTarget(c101108012.thtg)
	e2:SetOperation(c101108012.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c101108012.cfilter1(c,e)
	local seq=c:GetSequence()
	if seq>4 then return false end
	return ((seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
		  or(seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))) 
		and c:IsSetCard(0x27b) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c101108012.cfilter2(c,e)
	return c:GetColumnZone(LOCATION_MZONE,tp)>0 
		and c:IsSetCard(0x27b) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c101108012.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local lg=Duel.GetMatchingGroup(c101108012.cfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local zone=0
	for tc in aux.Next(lg) do
		local seq=tc:GetSequence()  
		if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then 
			zone=bit.bor(zone,(1<<(seq-1)))
		end
		if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then 
			zone=bit.bor(zone,(1<<(seq+1)))
		end
	end
	local lg1=Duel.GetMatchingGroup(c101108012.cfilter2,tp,LOCATION_MZONE,0,nil,e)
	for tc in aux.Next(lg1) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c101108012.hspval(e,c)
	local tp=c:GetControler()
	local lg=Duel.GetMatchingGroup(c101108012.cfilter1,tp,LOCATION_MZONE,0,nil,e)
	local zone=0
	for tc in aux.Next(lg) do
		local seq=tc:GetSequence()  
		if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then 
			zone=bit.bor(zone,(1<<(seq-1)))
		end
		if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then 
			zone=bit.bor(zone,(1<<(seq+1)))
		end
	end
	local lg1=Duel.GetMatchingGroup(c101108012.cfilter2,tp,LOCATION_MZONE,0,nil,e)
	for tc in aux.Next(lg1) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
	end
	return 0,zone
end
function c101108012.thfilter(c)
	return c:IsSetCard(0x27b) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() 
end
function c101108012.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101108012.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	if Duel.GetMatchingGroupCount(Card.IsDefensePos,tp,LOCATION_MZONE,LOCATION_MZONE,nil)>=3 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	end
end
function c101108012.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101108012.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsPlayerCanDraw(tp,1)
			and Duel.GetMatchingGroupCount(Card.IsDefensePos,tp,LOCATION_MZONE,LOCATION_MZONE,nil)>=3
			and Duel.SelectYesNo(tp,aux.Stringid(101108012,0)) then
			Duel.BreakEffect()
			Duel.ShuffleDeck(tp)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
