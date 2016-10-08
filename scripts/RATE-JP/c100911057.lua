--札再生
--Card Regeneration
--Script by nekrozar
function c100911057.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100911057,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100911057.target)
	e1:SetOperation(c100911057.activate)
	c:RegisterEffect(e1)
	--mill
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100911057,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c100911057.milcon)
	e2:SetTarget(c100911057.miltg)
	e2:SetOperation(c100911057.milop)
	c:RegisterEffect(e2)
end
function c100911057.filter(c)
	return c:IsSetCard(0xe6) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c100911057.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c100911057.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100911057.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c100911057.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c100911057.spfilter(c,e,tp)
	return c:IsSetCard(0xe6) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c100911057.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		local tg=Duel.GetMatchingGroup(c100911057.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
		if tg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.SelectYesNo(tp,aux.Stringid(100911057,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=tg:Select(tp,1,1,nil)
			Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end
function c100911057.milcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return e:GetHandler():IsReason(REASON_EFFECT) and rc:IsSetCard(0xe6) and rc:IsType(TYPE_MONSTER)
end
function c100911057.miltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
end
function c100911057.milfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c100911057.milop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		if g:IsExists(c100911057.milfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(100911057,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,c100911057.milfilter,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			g:Sub(sg)
		end
		Duel.SortDecktop(tp,tp,g:GetCount())
	end
end
