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
function c100280003.thfilter(c)
	return c:IsAbleToHand() and c:IsCode(64788463,25652259,90876561)
end
function c100280003.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(64788463,25652259,90876561)
end
function c100280003.opfilter(c,e,tp)
	return c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(64788463,25652259,90876561)
end
function c100280003.opcheck(g,e,tp)
	return g:GetClassCount(Card.GetCode)==#g
		and (g:FilterCount(c100280003.thfilter,nil)==2 or g:FilterCount(c100280003.spfilter,nil,e,tp)==2)
end
function c100280003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetMZoneCount(tp,e:GetHandler())
	if chk==0 then
		local g1=Duel.GetMatchingGroup(c100280003.thfilter,tp,LOCATION_DECK,0,nil)
		local g2=Duel.GetMatchingGroup(c100280003.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		return g1:GetClassCount(Card.GetCode)>=2
			or not Duel.IsPlayerAffectedByEffect(tp,59822133) and ft>1 and g2:GetClassCount(Card.GetCode)>=2 end
end
function c100280003.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g1=Duel.GetMatchingGroup(c100280003.thfilter,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c100280003.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	local g3=Duel.GetMatchingGroup(c100280003.opfilter,tp,LOCATION_DECK,0,nil,e,tp)
	local cg1=g1:GetClassCount(Card.GetCode)
	local cg2=g2:GetClassCount(Card.GetCode)
	if (Duel.IsPlayerAffectedByEffect(tp,59822133) or ft<=1 or cg2<2) and cg1>=2 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=g1:SelectSubGroup(tp,aux.dncheck,false,2,2)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	elseif cg1<2 and cg2>=2 and ft>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=g2:SelectSubGroup(tp,aux.dncheck,false,2,2)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	elseif cg1>=2 or (cg2>=2 and ft>1) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=g3:SelectSubGroup(tp,c100280003.opcheck,false,2,2,e,tp)
		local tg=g:FilterCount(c100280003.thfilter,nil)
		local sg=g:FilterCount(c100280003.spfilter,nil,e,tp)
		if tg>1 and (sg<2 or ft<=1 or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		else 
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
