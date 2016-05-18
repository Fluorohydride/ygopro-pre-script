--天声の服従
--Lullaby of Obedience
--Script by mercury233
function c100417008.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c100417008.cost)
	e1:SetTarget(c100417008.target)
	e1:SetOperation(c100417008.activate)
	c:RegisterEffect(e1)
end
function c100417008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000)
	else Duel.PayLPCost(tp,2000) end
end
function c100417008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_DECK,1,nil)
		or Duel.IsPlayerCanSpecialSummon(tp) end
	Duel.Hint(HINT_SELECTMSG,tp,564)
	local ac=Duel.AnnounceCard(tp,TYPE_MONSTER)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c100417008.activate(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	if g:GetCount()<1 then return end
	Duel.ConfirmCards(1-tp,g)
	Duel.Hint(HINT_SELECTMSG,1-tp,526)
	local sg=g:FilterSelect(1-tp,Card.IsCode,1,1,nil,ac)
	local tc=sg:GetFirst()
	if tc then
		Duel.ConfirmCards(tp,sg)
		local b1=tc:IsAbleToHand()
		local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and tc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,1-tp,true,false,POS_FACEUP_ATTACK,tp)
		local sel=0
		if b1 and b2 then
			Duel.Hint(HINT_SELECTMSG,1-tp,555)
			sel=Duel.SelectOption(1-tp,aux.Stringid(100417008,0),aux.Stringid(100417008,1))+1
		elseif b1 then
			Duel.Hint(HINT_SELECTMSG,1-tp,555)
			sel=Duel.SelectOption(1-tp,aux.Stringid(100417008,0))+1
		elseif b2 then
			Duel.Hint(HINT_SELECTMSG,1-tp,555)
			sel=Duel.SelectOption(1-tp,aux.Stringid(100417008,1))+2
		end
		if sel==1 then
			Duel.SendtoHand(sg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		elseif sel==2 then
			Duel.SpecialSummon(sg,0,1-tp,tp,true,false,POS_FACEUP_ATTACK)
		end
	else
		Duel.ConfirmCards(tp,g)
	end
	Duel.ShuffleDeck(tp)
end
