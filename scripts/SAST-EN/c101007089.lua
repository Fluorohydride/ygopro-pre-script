--Valkyrie Vierte
--Script by JoyJ
function c101007089.initial_effect(c)
	--deck search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101007089,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101007089)
	e1:SetTarget(c101007089.target)
	e1:SetOperation(c101007089.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101007089,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetCountLimit(1,101007089+100)
	e2:SetCondition(c101007089.spcon)
	e2:SetTarget(c101007089.sptg)
	e2:SetOperation(c101007089.spop)
	c:RegisterEffect(e2)
end
function c101007089.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x122)
end
function c101007089.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=Duel.GetMatchingGroupCount(c101007089.ctfilter,tp,LOCATION_MZONE,0,e:GetHandler())
		if ct==0 or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<ct then return false end
		local g=Duel.GetDecktopGroup(tp,ct)
		return g:FilterCount(Card.IsAbleToHand,nil)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c101007089.thfilter(c)
	return c:GetType()==TYPE_SPELL or c:GetType()==TYPE_TRAP
end
function c101007089.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c101007089.ctfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	if ct==0 then return end
	local g=Duel.GetDecktopGroup(tp,ct)
	Duel.ConfirmDecktop(tp,ct)
	tg=g:Filter(c101007089.thfilter,nil)
	if tg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=tg:Select(tp,1,1,nil):GetFirst()
		if tc:IsAbleToHand() then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
			Duel.ShuffleHand(tp)
		else
			Duel.SendtoGrave(tc,REASON_RULE)
		end
		g:RemoveCard(tc)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
	end
	Duel.ShuffleDeck(tp)
end
function c101007089.spfilter(c,e,tp)
	return c:IsSetCard(0x122) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101007089.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE)
end
function c101007089.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101007089.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101007089.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101007089.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
