--聖魔の乙女アルテミス

--Scripted by mallu11
function c100415008.initial_effect(c)
	c:SetSPSummonOnce(100415008)
	--link summon
	aux.AddLinkProcedure(c,c100415008.mfilter,1,1)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100415008,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100415008)
	e1:SetCondition(c100415008.eqcon)
	e1:SetTarget(c100415008.eqtg)
	e1:SetOperation(c100415008.eqop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--to hand(equip)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100415008,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,100415108)
	e3:SetCondition(c100415008.thcon)
	e3:SetTarget(c100415008.thtg)
	e3:SetOperation(c100415008.thop)
	c:RegisterEffect(e3)
end
function c100415008.mfilter(c)
	return c:IsLevelBelow(4) and c:IsLinkRace(RACE_SPELLCASTER)
end
function c100415008.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0x251)
end
function c100415008.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100415008.confilter,1,nil) and not eg:IsContains(e:GetHandler())
end
function c100415008.eqfilter(c,g)
	return g:IsContains(c)
end
function c100415008.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=eg:Filter(c100415008.confilter,nil)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c100415008.eqfilter(chkc,g) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c100415008.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,g) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c100415008.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,g)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c100415008.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() or not c:IsControler(tp) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc) then return end
	--equip limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetLabelObject(tc)
	e1:SetValue(c100415008.eqlimit)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function c100415008.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c100415008.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()
end
function c100415008.thfilter(c)
	return c:IsSetCard(0x251) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c100415008.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100415008.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100415008.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100415008.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
