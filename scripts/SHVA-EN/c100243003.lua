--ワルキューレ・アルテスト
--Valkyrie Erste
--scripted by AlphaKretin
function c100243003.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e1:SetDescription(aux.Stringid(100243003,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c100243003.thcon)
	e1:SetTarget(c100243003.thtg)
	e1:SetOperation(c100243003.thop)
	e1:SetCountLimit(1,100243003)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_LEAVE_GRAVE)
	e2:SetDescription(aux.Stringid(100243003,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c100243003.rmcon)
	e2:SetTarget(c100243003.rmtg)
	e2:SetOperation(c100243003.rmop)
	e2:SetCountLimit(1,100243003+1000)
	c:RegisterEffect(e2)
end
c100243003.listed_names={100243007}
function c100243003.thcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsType(TYPE_SPELL) and e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c100243003.thfilter(c)
	return c:IsCode(100243007) and c:IsAbleToHand()
end
function c100243003.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c100243003.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100243003.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c100243003.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c100243003.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c100243003.cfilter(c)
	return c:IsSetCard(0x228) and not c:IsCode(100243003)
end
function c100243003.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100243003.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100243003.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c100243003.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=Duel.SelectMatchingCard(tp,Card.IsCanRemove,tp,0,LOCATION_GRAVE,1,1,nil):GetFirst()
	if rc then
		if Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and c:IsFaceup() then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(rc:GetBaseAttack())
			c:RegisterEffect(e1)
		end
	end
end
