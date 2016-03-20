--EMコン
--Performance Corn
--Script by mercury233
function c100206003.initial_effect(c)
	--summon reg
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(c100206003.spreg)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100206003,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c100206003.thcon)
	e3:SetTarget(c100206003.thtg)
	e3:SetOperation(c100206003.thop)
	c:RegisterEffect(e3)
	--lp recover
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100206003,1))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c100206003.lpcon)
	e4:SetCost(c100206003.lpcost)
	e4:SetTarget(c100206003.lptg)
	e4:SetOperation(c100206003.lpop)
	c:RegisterEffect(e4)
end
function c100206003.spreg(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(100206003,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
end
function c100206003.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(100206003)~=0
end
function c100206003.filter(c)
	return c:IsSetCard(0x9f) and c:IsPosition(POS_FACEUP_ATTACK) and c:IsAttackBelow(1000)
end
function c100206003.thfilter(c)
	return c:IsSetCard(0x99) and c:IsAbleToHand()
end
function c100206003.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100206003.thfilter,tp,LOCATION_DECK,0,1,nil)
		and e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
		and Duel.IsExistingTarget(c100206003.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	local g=Duel.SelectTarget(tp,c100206003.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100206003.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (c:IsRelateToEffect(e) and c:IsPosition(POS_FACEUP_ATTACK)
			and tc:IsRelateToEffect(e) and tc:IsPosition(POS_FACEUP_ATTACK)) then return end
	Duel.ChangePosition(c,POS_FACEUP_DEFENCE)
	Duel.ChangePosition(tc,POS_FACEUP_DEFENCE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100206003.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100206003.cfilter(c)
	return c:IsSetCard(0x9f) and c:IsAbleToRemoveAsCost() and not c:IsCode(100206003)
end
function c100206003.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c100206003.lpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c100206003.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c100206003.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c100206003.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c100206003.lpop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
