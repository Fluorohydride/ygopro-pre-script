--魔轟神界の階
--
--Script by JustFish
function c101103060.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101103060+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c101103060.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101103060,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_HANDES)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,101103060)
	e2:SetTarget(c101103060.thtg)
	e2:SetOperation(c101103060.thop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c101103060.atktg)
	e3:SetCondition(c101103060.atkcon)
	e3:SetValue(c101103060.atkval)
	c:RegisterEffect(e3)
end
function c101103060.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x35) and c:IsAbleToGrave()
end
function c101103060.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c101103060.tgfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101103060,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c101103060.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x35) and c:IsAbleToHand()
end
function c101103060.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101103060.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101103060.thfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectTarget(tp,c101103060.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,2)
end
function c101103060.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.DiscardHand(tp,aux.TRUE,2,2,REASON_EFFECT+REASON_DISCARD)>1 and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c101103060.atktg(e,c)
	return c:IsSetCard(0x35) and Duel.GetAttacker()==c
end
function c101103060.atkcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and Duel.GetAttackTarget()~=nil
		and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
end
function c101103060.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa9,0xad)
end
function c101103060.atkval(e,c)
	local ct=Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_HAND)-Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)
	return ct>0 and ct*200
end
