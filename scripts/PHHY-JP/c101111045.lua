--ギガンティック“チャンピオン”サルガス
--Script by 神数不神
function c101111045.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2,c101111045.ovfilter,aux.Stringid(101111045,0),99,c101111045.xyzop)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101111045,1))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101111045)
	e1:SetTarget(c101111045.srcon)
	e1:SetTarget(c101111045.srtg)
	e1:SetOperation(c101111045.srop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101111045,2))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_DETACH_MATERIAL)
	e2:SetCountLimit(1,101111046)
	e2:SetTarget(c101111045.destg)
	e2:SetOperation(c101111045.desop)
	c:RegisterEffect(e2)
end
function c101111045.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x155) and c:IsType(TYPE_XYZ)
end
function c101111045.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,101111045)==0 end
	Duel.RegisterFlagEffect(tp,101111045,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c101111045.srcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>0
end

function c101111045.srfilter(c)
	return (c:IsSetCard(0x155) or c:IsSetCard(0x179)) and c:IsAbleToHand()
end
function c101111045.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101111045.srfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101111045.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101111045.srfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101111045.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101111045,3))
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if not g:GetFirst():IsAbleToHand() then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function c101111045.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(101111045,4)) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.Destroy(tc,REASON_EFFECT)
	end
end