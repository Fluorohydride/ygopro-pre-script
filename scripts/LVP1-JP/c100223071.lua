--セフィラ・メタトロン
--Zefra Metaltron
--Scripted by Eerie Code
function c100223071.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c100223071.matfilter,2)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_LEAVE_FIELD_P)
	e1:SetOperation(c100223071.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100223071,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_CUSTOM+100223071)
	e2:SetCountLimit(1,100223071)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c100223071.thtg)
	e2:SetOperation(c100223071.thop)
	c:RegisterEffect(e2)
	--banish
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100223071,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,100223071+100)
	e3:SetTarget(c100223071.rmtg)
	e3:SetOperation(c100223071.rmop)
	c:RegisterEffect(e3)
end
function c100223071.matfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function c100223071.thcfilter(c,tp,lg)
	return c:GetPreviousControler()==tp and lg:IsContains(c) and c:GetSummonLocation()==LOCATION_EXTRA and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c100223071.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg and eg:IsExists(c100223071.thcfilter,1,nil,tp,c:GetLinkedGroup()) and rp~=tp then
		Duel.RaiseSingleEvent(c,EVENT_CUSTOM+100223071,e,0,tp,0,0)
	end
end
function c100223071.thfilter(c)
	return (not c:IsLocation(LOCATION_EXTRA) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c100223071.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100223071.thfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c100223071.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100223071.thfilter),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100223071.rmfilter(c)
	return c:IsFaceup() and c:GetSummonLocation()==LOCATION_EXTRA and c:IsAbleToRemove()
end
function c100223071.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c100223071.rmfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
		and Duel.IsExistingTarget(c100223071.rmfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c100223071.rmfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,c100223071.rmfilter,tp,0,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,2,0,0)
end
function c100223071.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	for tc in aux.Next(g) do
		if Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			tc:RegisterFlagEffect(100223071,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabelObject(g)
	e1:SetCountLimit(1)
	e1:SetCondition(c100223071.retcon)
	e1:SetOperation(c100223071.retop)
	Duel.RegisterEffect(e1,tp)
end
function c100223071.retfilter(c)
	return c:GetFlagEffect(100223071)~=0
end
function c100223071.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():IsExists(c100223071.retfilter,1,nil)
end
function c100223071.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(c100223071.retfilter,nil)
	Duel.ReturnToField(g)
end
