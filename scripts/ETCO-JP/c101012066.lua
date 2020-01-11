--超重機回送

--Scripted by mallu11
function c101012066.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101012066+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c101012066.activate)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c101012066.postg)
	e2:SetOperation(c101012066.posop)
	c:RegisterEffect(e2)
end
function c101012066.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x127) and c:IsAbleToHand()
end
function c101012066.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c101012066.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101012066,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c101012066.pfilter1(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ) and c:IsCanChangePosition()
end
function c101012066.pfilter2(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ)
end
function c101012066.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=Duel.IsExistingTarget(c101012066.pfilter1,tp,LOCATION_MZONE,0,1,nil)
	local b2=Duel.IsExistingTarget(c101012066.pfilter2,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsCanOverlay()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and (c101012066.pfilter1(chkc) or c101012066.pfilter2(chkc) and e:GetHandler():IsCanOverlay()) end
	if chk==0 then return b1 or b2 end
	local opt=0
	local g=nil
	if b1 and not b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(101012066,1))
	end
	if not b1 and b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(101012066,2))+1
	end
	if b1 and b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(101012066,1),aux.Stringid(101012066,2))
	end
	e:SetLabel(opt)
	if opt==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		g=Duel.SelectTarget(tp,c101012066.pfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		g=Duel.SelectTarget(tp,c101012066.pfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	end
end
function c101012066.posop(e,tp,eg,ep,ev,re,r,rp)
	local opt=e:GetLabel()
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if opt==0 then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	else
		if c:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
			Duel.Overlay(tc,c)
		end
	end
end
