--ミレニアムシーカー
--Millenium Seeker
--LUA by Kohana Sonogami
--
function c100272006.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100272006,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetCountLimit(1,100272006)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c100272006.spcon)
	e1:SetTarget(c100272006.sptg)
	e1:SetOperation(c100272006.spop)
	c:RegisterEffect(e1)
	--special summon or todeck
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(100272006,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100272006+100)
	e2:SetTarget(c100272006.tdtg)
	e2:SetOperation(c100272006.tdop)
	c:RegisterEffect(e2) 
end
function c100272006.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and ev>=1000 and bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function c100272006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100272006.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100272006.filter(c,e,tp)
	return c:IsAttackAbove(0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100272006.thfilter(c)
	return c:IsAttackAbove(0) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c100272006.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c100272006.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c100272006.filter,tp,0,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c100272006.filter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100272006.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local vc=tc:GetTextAttack()
	if not tc:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c100272006.thfilter,tp,0,LOCATION_DECK,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(100272006,2))~=0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
		local sg=Duel.SelectMatchingCard(1-tp,c100272006.thfilter,tp,0,LOCATION_DECK,1,1,nil)
		Duel.ConfirmCards(1-tp,sg)
		if sg:GetFirst():GetTextAttack()<vc then
			Duel.ShuffleDeck(1-tp)
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(1-tp)
		end
	else
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end 
