--コード・エクスポーター

--Scripted by nekrozar
function c100254001.initial_effect(c)
	--hand link
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100254001)
	e1:SetValue(c100254001.matval)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100254001,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,100254101)
	e2:SetCondition(c100254001.thcon)
	e2:SetTarget(c100254001.thtg)
	e2:SetOperation(c100254001.thop)
	c:RegisterEffect(e2)
end
function c100254001.mfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_CYBERSE)
end
function c100254001.exmfilter(c)
	return c:IsLocation(LOCATION_HAND) and c:IsCode(100254001)
end
function c100254001.matval(e,c,mg)
	return c:IsSetCard(0x101) and mg:IsExists(c100254001.mfilter,1,nil) and not mg:IsExists(c100254001.exmfilter,1,nil)
end
function c100254001.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:SetLabel(0)
	if c:IsPreviousLocation(LOCATION_ONFIELD) then e:SetLabel(1) end
	return c:IsLocation(LOCATION_GRAVE) and c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND) and r==REASON_LINK and c:GetReasonCard():IsSetCard(0x101)
end
function c100254001.thfilter(c,e,tp,chk)
	return c:IsRace(RACE_CYBERSE) and c:IsLevelBelow(4)
		and (c:IsAbleToHand() or (chk==1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c100254001.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local check=e:GetLabel()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c100254001.thfilter(chkc,e,tp,check) end
	if chk==0 then return Duel.IsExistingTarget(c100254001.thfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,check) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c100254001.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,check)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c100254001.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if tc:IsAbleToHand()
		and (e:GetLabel()==0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.SelectOption(tp,1190,1152)==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	else
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
		Duel.SpecialSummonComplete()
	end
end
