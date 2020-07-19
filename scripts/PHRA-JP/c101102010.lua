--電脳堺媛－瑞々
--
--Script by JustFish
function c101102010.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101102010,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101102010)
	e1:SetTarget(c101102010.sptg)
	e1:SetOperation(c101102010.spop)
	c:RegisterEffect(e1)
end
function c101102010.tfilter(c,tp)
	local type1=c:GetType()&0x7
	return c:IsSetCard(0x24e) and c:IsFaceup() and Duel.IsExistingMatchingCard(c101102010.tgfilter,tp,LOCATION_DECK,0,1,nil,tp,type1)
end
function c101102010.tgfilter(c,type1)
	return not c:IsType(type1) and c:IsSetCard(0x24e) and c:IsAbleToGrave()
end
function c101102010.thfilter(c,type1)
	return not c:IsType(type1) and c:IsSetCard(0x24e) and not c:IsCode(101102010) and c:IsAbleToHand()
end
function c101102010.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c101102010.tfilter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c101102010.tfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c101102010.tfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101102010.spop(e,tp,eg,ep,ev,re,r,rp)
	local c,tc=e:GetHandler(),Duel.GetFirstTarget()
	local type1=tc:GetType()&0x7
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c101102010.tgfilter,tp,LOCATION_DECK,0,1,1,nil,type1)
		local tgc=g:GetFirst()
		if tgc and Duel.SendtoGrave(tgc,REASON_EFFECT)~=0 and tgc:IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e)
			and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local type1=tgc:GetType()&0x7|type1
			local sg=Duel.GetMatchingGroup(c101102010.thfilter,tp,LOCATION_DECK,0,nil,type1)
			if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(101102010,1)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local hg=sg:Select(tp,1,1,nil)
				if #hg>0 then
					Duel.SendtoHand(hg,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,hg)
				end
			end
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101102010.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101102010.splimit(e,c)
	return not (c:IsLevelAbove(3) or c:IsRankAbove(3))
end
