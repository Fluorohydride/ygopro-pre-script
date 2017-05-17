--サイバー・ダーク・クロー
--Cyberdark Claw
--Scripted by sahim
function c100418100.initial_effect(c)
	--search monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100418100,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c100418100.con)
	e1:SetTarget(c100418100.tg)
	e1:SetOperation(c100418100.op)
	c:RegisterEffect(e1)
	--search S/T
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100418100,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,100418100)
	e2:SetCost(c100418100.cost)
	e2:SetTarget(c100418100.target)
	e2:SetOperation(c100418100.operation)
	c:RegisterEffect(e2)
	--send to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100418100,2))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,100418100+100)
	e3:SetCondition(c100418100.gycon)
	e3:SetTarget(c100418100.gytg)
	e3:SetOperation(c100418100.gyop)
	c:RegisterEffect(e3)
end
function c100418100.filter1(c)
	return (c:IsSetCard(0x4093) or c:IsCode(40418351,77625948,41230939,3019642))
		and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c100418100.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousLocation()==LOCATION_SZONE and not c:IsReason(REASON_LOST_TARGET)
end
function c100418100.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c100418100.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100418100.filter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c100418100.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c100418100.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c100418100.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c100418100.filter2(c)
	return (c:IsSetCard(0x4093) or c:IsCode(40418351,77625948,41230939,3019642))
		and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c100418100.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c100418100.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100418100.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.SelectMatchingCard(tp,c100418100.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if tg:GetCount()>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c100418100.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c100418100.gycon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and (ec==Duel.GetAttacker() or ec==Duel.GetAttackTarget())
end
function c100418100.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100418100.tgfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_EXTRA)
end
function c100418100.gyop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100418100.tgfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
