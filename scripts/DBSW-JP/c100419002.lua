--影六武衆－ゲンバ
--Shadow Six Samurai – Genba
--Scripted by Eerie Code
function c100419002.initial_effect(c)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100419002,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c100419002.thtg)
	e1:SetOperation(c100419002.thop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c100419002.reptg)
	e2:SetValue(c100419002.repval)
	e2:SetOperation(c100419002.repop)
	c:RegisterEffect(e2)
end
function c100419002.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3d) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c100419002.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c100419002.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100419002.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c100419002.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c100419002.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c100419002.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3d)
		and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsReason(REASON_EFFECT)
end
function c100419002.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c100419002.repfilter,1,nil,tp)
		and eg:GetCount()==1 end
	return Duel.SelectYesNo(tp,aux.Stringid(100419002,1))
end
function c100419002.repval(e,c)
	return c100419002.repfilter(c,e:GetHandlerPlayer())
end
function c100419002.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
