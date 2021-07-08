--Imperial Bower
--script by 222DIY
function c100280003.initial_effect(c)
	aux.AddCodeList(c,25652259,64788463,90876561)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100280003,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100280003)
	e1:SetCondition(c100280003.spcon)
	e1:SetCost(c100280003.spcost)
	e1:SetTarget(c100280003.sptg)
	e1:SetOperation(c100280003.spop)
	c:RegisterEffect(e1)
end
function c100280003.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1
end
function c100280003.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c100280003.opfilter(c,e,tp)
	return (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false)) and c:IsCode(64788463,25652259,90876561)
end
function c100280003.opcheck(g,e,tp,spcheck)
	return g:GetClassCount(Card.GetCode)==2
		and (g:FilterCount(Card.IsAbleToHand,nil)==2 or g:FilterCount(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false)==2)
end
function c100280003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local spcheck=Duel.GetMZoneCount(tp,e:GetHandler())>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		local g=Duel.GetMatchingGroup(c100280003.opfilter,tp,LOCATION_DECK,0,nil,e,tp)
		return g:CheckSubGroup(c100280003.opcheck,2,2,e,tp,spcheck)
	end
end
function c100280003.spop(e,tp,eg,ep,ev,re,r,rp)
	local spcheck=Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
	local g=Duel.GetMatchingGroup(c100280003.opfilter,tp,LOCATION_DECK,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sg=g:SelectSubGroup(tp,c100280003.opcheck,false,2,2,e,tp,spcheck)
	if not sg then return end
	local tgc=sg:FilterCount(Card.IsAbleToHand,nil)
	local sgc=sg:FilterCount(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false)
	if tgc==2 and (sgc~=2 or not spcheck or Duel.SelectOption(tp,1190,1152)==0) then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	else
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
