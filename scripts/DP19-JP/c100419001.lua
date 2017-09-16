--ミレニアム・アイズ・イリュージョニスト
--Millennium-Eyes Illusionist
function c100419001.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100419001,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100419001)
	e1:SetCost(c100419001.eqcost)
	e1:SetTarget(c100419001.eqtg)
	e1:SetOperation(c100419001.eqop)
	c:RegisterEffect(e1)	
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100419001,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100419001+100)
	e2:SetCondition(c100419001.thcon)
	e2:SetTarget(c100419001.thtg)
	e2:SetOperation(c100419001.thop)
	c:RegisterEffect(e2)
end
function c100419001.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c100419001.filter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and Duel.IsExistingMatchingCard(c100419001.eqfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100419001.eqfilter(c)
	local m=_G["c"..c:GetCode()]
	return c:IsFaceup() and ((c:IsSetCard(0x20a) and c:IsType(TYPE_FUSION))or c:IsCode(64631466,63519819)) and m.CanEquipMonster(c)
end
function c100419001.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c100419001.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c100419001.filter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c100419001.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c100419001.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc1=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c100419001.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc2=g:GetFirst()
	if not tc2 then return end
	local m=_G["c"..tc2:GetCode()]
	if tc1:IsFaceup() and tc1:IsRelateToEffect(e) and tc1:IsControler(1-tp) then
		m.EquipMonster(tc2,tp,tc1)
	end
end
function c100419001.thfilter(c,e)
	return (c:IsSetCard(0x20a) and c:IsType(TYPE_FUSION)) or c:IsCode(64631466,63519819)
end
function c100419001.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100419001.thfilter,1,nil)
end
function c100419001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c100419001.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
