--エレメントセイバー・ナル
--Elementsaber Naru
--Scripted by Eerie Code
function c101004021.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101004021,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCost(c101004021.thcost)
	e1:SetTarget(c101004021.thtg)
	e1:SetOperation(c101004021.thop)
	c:RegisterEffect(e1)
	--att change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101004021,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetTarget(c101004021.atttg)
	e2:SetOperation(c101004021.attop)
	c:RegisterEffect(e2)
end
function c101004021.costfilter(c)
	return c:IsSetCard(0x400d) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c101004021.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,101004060)}) do
		fg:AddCard(pe:GetHandler())
	end
	local loc=LOCATION_HAND
	if fg:GetCount()>0 then loc=LOCATION_HAND+LOCATION_DECK end
	if chk==0 then return Duel.IsExistingMatchingCard(c101004021.costfilter,tp,loc,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c101004021.costfilter,tp,loc,0,1,1,nil):GetFirst()
	if tc:IsLocation(LOCATION_DECK) then
		local fc=nil
		if fg:GetCount()==1 then
			fc=fg:GetFirst()
		else
			fc=fg:Select(tp,1,1,nil)
		end
		Duel.Hint(HINT_CARD,0,fc:GetCode())
		fc:RegisterFlagEffect(101004060,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
	end
	Duel.SendtoGrave(tc,REASON_COST)
end
function c101004021.thfilter(c)
	return (c:IsSetCard(0x400d) or c:IsSetCard(0x212)) and c:IsType(TYPE_MONSTER) and not c:IsCode(101004021) and c:IsAbleToHand()
end
function c101004021.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101004021.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101004021.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101004021.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101004021.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c101004021.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local att=Duel.AnnounceAttribute(tp,1,0xff-e:GetHandler():GetAttribute())
	e:SetLabel(att)
end
function c101004021.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
