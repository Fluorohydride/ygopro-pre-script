--ゴールデンアイドル
--Golden Idol
--LUA by Kohana Sonogami
--
function c100273005.initial_effect(c)
	--Change the Name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100273005)
	e1:SetTarget(c100273005.rntg)
	e1:SetOperation(c100273005.rnop)
	c:RegisterEffect(e1)
	--Equip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,100273005+100)
	e2:SetTarget(c100273005.eqtg)
	e2:SetOperation(c100273005.eqop)
	c:RegisterEffect(e2)
	local e3x=e2:Clone()
	e3x:SetCode(EVENT_TO_GRAVE)
	e3x:SetCondition(c100273005.eqcon)
	c:RegisterEffect(e3x)
end
function c100273005.rntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
end
function c100273005.rnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.NOT(Card.IsPublic),tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		Duel.ShuffleHand(1-tp)
	end
	if c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(27125110)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c100273005.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c100273005.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsAbleToChangeControler()
end
function c100273005.eqfilter(c)
	local m=_G["c"..c:GetCode()]
	return c:IsFaceup() and ((c:IsSetCard(0x110) and c:IsType(TYPE_MONSTER)) or c:IsCode(64631466))
		and m.can_equip_monster(c) and not c:IsSummonableCard()
end
function c100273005.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c100273005.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c100273005.filter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c100273005.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c100273005.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c100273005.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc1=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c100273005.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc2=g:GetFirst()
	if not tc2 then return end
	local m=_G["c"..tc2:GetCode()]
	if tc1:IsFaceup() and tc1:IsRelateToEffect(e) and tc1:IsControler(1-tp) then
		m.equip_monster(tc2,tp,tc1)
	end
end
