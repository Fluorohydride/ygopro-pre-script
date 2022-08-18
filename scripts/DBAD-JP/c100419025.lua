--剣の御巫ハレ
--
--Script by Trishula9
function c100419025.initial_effect(c)
	--no damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c100419025.ndcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	e2:SetCondition(c100419025.indcon)
	c:RegisterEffect(e2)
	--reflect battle damage
	local e3=e2:Clone()
	e3:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_EQUIP)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,100419025)
	e4:SetTarget(c100419025.thtg)
	e4:SetOperation(c100419025.thop)
	c:RegisterEffect(e4)
end
function c100419025.ndcon(e)
	return e:GetHandler():GetEquipCount()==0
end
function c100419025.indcon(e)
	return e:GetHandler():GetEquipCount()>0
end
function c100419025.thfilter(c)
	return c:IsSetCard(0x28d) and c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c100419025.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100419025.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100419025.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100419025.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end