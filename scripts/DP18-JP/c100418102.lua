--サイバーダーク・インフェルノ
--Cyberdark Inferno
--Scripted by sahim
function c100418102.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(c100418102.indestg)
	e2:SetValue(c100418102.indesval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--return to hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetTarget(c100418102.target)
	e4:SetOperation(c100418102.operation)
	e4:SetCountLimit(1,100418102)
	c:RegisterEffect(e4)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCondition(c100418102.thcon)
	e5:SetTarget(c100418102.thtg)
	e5:SetOperation(c100418102.thop)
	c:RegisterEffect(e5)
end
function c100418102.indestg(e,c)
	return (c:IsSetCard(0x4093) or c:IsCode(40418351,77625948,41230939,3019642)) 
		and c:IsType(TYPE_EFFECT) and c:GetEquipCount()>0
end
function c100418102.indesval(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c100418102.filter(c)
	return (c:IsSetCard(0x4093) or c:IsCode(40418351,77625948,41230939,3019642)) 
		and c:IsFaceup() and c:IsAbleToHand()
end
function c100418102.filter2(c)
	return (c:IsSetCard(0x4093) or c:IsCode(40418351,77625948,41230939,3019642)) and c:IsSummonable(true,nil)
end
function c100418102.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chk(c:IsSetCard(0x4093) or c:IsCode(40418351,77625948,41230939,3019642)) and chkc:IsType(TYPE_MONSTER) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(c100418102.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c100418102.filter2,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c100418102.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c100418102.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g=Duel.SelectMatchingCard(tp,c100418102.filter2,tp,LOCATION_HAND,0,1,1,nil)
		tc=g:GetFirst()
		if tc then
			Duel.Summon(tp,tc,true,nil)
		end
	end
end
function c100418102.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and c:IsReason(REASON_DESTROY) and c:GetPreviousControler()==tp
end
function c100418102.thfilter(c)
	return c:IsSetCard(0x46) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c100418102.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100418102.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100418102.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100418102.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
