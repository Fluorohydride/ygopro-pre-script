--壱世壊＝ペルレイノ
--
--Script by JoyJ
function c101109060.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101109060+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c101109060.activate)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c101109060.atktg)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101109060,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,101109060+100)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetCondition(c101109060.descon)
	e3:SetTarget(c101109060.destg)
	e3:SetOperation(c101109060.desop)
	c:RegisterEffect(e3)
end
function c101109060.filter(c)
	return ((c:IsSetCard(0x284) and c:IsType(TYPE_MONSTER)) or c:IsCode(56099748)) and c:IsAbleToHand()
end
function c101109060.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101109060.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(101109060,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c101109060.atktg(e,c)
	return c:IsType(TYPE_FUSION) or c:IsSetCard(0x284)
end
function c101109060.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousControler(tp) and c:IsSetCard(0x284)
		and (c:IsPreviousLocation(LOCATION_GRAVE)
			or (c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)))
end
function c101109060.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101109060.cfilter,1,nil,tp)
end
function c101109060.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101109060.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
