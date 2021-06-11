--うにの軍貫
--scripted by XyLeN
function c101106022.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101106022,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101106022)
	e1:SetCost(c101106022.spcost)
	e1:SetTarget(c101106022.sptg)
	e1:SetOperation(c101106022.spop)
	c:RegisterEffect(e1)
	--change level
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101106022,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,101106022+100)
	e2:SetTarget(c101106022.lvltg)
	e2:SetOperation(c101106022.lvlop)
	c:RegisterEffect(e2)
end
function c101106022.cfilter(c)
	return c:IsSetCard(0x166) and not c:IsPublic()
end
function c101106022.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101106022.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c101106022.cfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	g:KeepAlive()
	e:SetLabelObject(g)
end
function c101106022.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101106022.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=e:GetLabelObject()
		local tc=g:GetFirst()
		if tc:GetCode()==24639891 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(101106022,2)) then
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		elseif tc:IsAbleToDeck() then
			Duel.BreakEffect()
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		end
		g:DeleteGroup()
	end
end
function c101106022.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x166)
end
function c101106022.lvltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101106022.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101106022.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101106022.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c101106022.thfilter(c)
	return c:IsCode(24639891) and c:IsAbleToHand()
end
function c101106022.lvlop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local sel=1
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		sel=Duel.SelectOption(tp,aux.Stringid(101106022,3),aux.Stringid(101106022,4))
	else
		sel=Duel.SelectOption(tp,aux.Stringid(101106022,3))+1
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	if opt==0 then
		e1:SetValue(4)
	else
		e1:SetValue(5)
	end
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	if Duel.IsExistingMatchingCard(c101106022.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(101106022,5)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c101106022.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
