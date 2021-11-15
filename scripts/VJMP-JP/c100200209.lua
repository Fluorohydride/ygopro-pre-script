--海神の依代
--
--Script by Trishula9
function c100200209.initial_effect(c)
	aux.AddCodeList(c,22702055)
	--choose effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100200209,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,100200209)
	e1:SetTarget(c100200209.target)
	e1:SetOperation(c100200209.operation)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,100200209+100)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c100200209.thtg)
	e2:SetOperation(c100200209.thop)
	c:RegisterEffect(e2)
end
function c100200209.cpfilter(c,ec)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsLevelAbove(1) and (not c:IsLevel(ec:GetLevel()) or c:IsCode(ec:GetCode()))
end
function c100200209.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c100200209.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c:IsAttribute(ATTRIBUTE_WATER) end
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c100200209.cpfilter,tp,LOCATION_GRAVE,0,1,nil,c)
	local b2=Duel.IsEnvironment(22702055) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100200209.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local s=0
	local g=nil
	if b1 and not b2 then
		s=Duel.SelectOption(tp,aux.Stringid(100200209,1))
	end
	if not b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(100200209,2))+1
	end
	if b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(100200209,1),aux.Stringid(100200209,2))
	end
	e:SetLabel(s)
	if s==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		g=Duel.SelectTarget(tp,c100200209.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil,c)
		e:SetCategory(0)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=Duel.SelectTarget(tp,c100200209.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
end
function c100200209.operation(e,tp,eg,ep,ev,re,r,rp)
	local s=e:GetLabel()
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if s==0 and tc and tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(tc:GetCode())
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_LEVEL)
		e2:SetValue(tc:GetLevel())
		c:RegisterEffect(e2)
	end
	if s==1 and tc and tc:IsRelateToEffect(e) and Duel.IsEnvironment(22702055) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c100200209.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c100200209.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
function c100200209.thfilter(c)
	return c:IsCode(22702055) and c:IsAbleToHand()
end
function c100200209.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c100200209.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100200209.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c100200209.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c100200209.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
