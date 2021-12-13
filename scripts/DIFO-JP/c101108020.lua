--音響戦士ギタリス
--
--Script by Trishula9
function c101108020.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pzone
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101108020,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101108020)
	e1:SetTarget(c101108020.ptg)
	e1:SetOperation(c101108020.pop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101108020,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,101108020+100)
	e2:SetCondition(c101108020.spcon)
	e2:SetTarget(c101108020.sptg)
	e2:SetOperation(c101108020.spop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101108020,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,101108020+200)
	e3:SetTarget(c101108020.thtg)
	e3:SetOperation(c101108020.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c101108020.pfilter(c)
	return c:IsSetCard(0x1066) and c:IsFaceup() and c:IsAbleToHand()
end
function c101108020.ptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c101108020.pfilter(chkc) end
	if chk==0 then return c:IsAbleToHand()
		and Duel.IsExistingTarget(c101108020.pfilter,tp,LOCATION_ONFIELD,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c101108020.pfilter,tp,LOCATION_ONFIELD,0,1,1,c)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function c101108020.pop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Group.FromCards(c,tc):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==2 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c101108020.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEnvironment(75304793,tp,LOCATION_FZONE)
end
function c101108020.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101108020.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101108020.thfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c101108020.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and c101108020.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101108020.thfilter,tp,LOCATION_PZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c101108020.thfilter,tp,LOCATION_PZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101108020.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end