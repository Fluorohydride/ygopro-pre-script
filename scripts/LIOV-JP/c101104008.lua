--驚楽園の案内人 ＜Comica＞
--Amazement Attendant <Comica>
--Scripted by Kohana Sonogami
function c101104008.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101104008,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c101104008.settg)
	e1:SetOperation(c101104008.setop)
	c:RegisterEffect(e1)
	--equip change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101104008,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,101104008)
	e2:SetTarget(c101104008.eqtg)
	e2:SetOperation(c101104008.eqop)
	c:RegisterEffect(e2)
end
function c101104008.setfilter(c)
	return c:IsSetCard(0x25f) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c101104008.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101104008.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c101104008.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,c101104008.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SSet(tp,tc)
	end
end
function c101104008.eqfilter1(c)
	return c:IsSetCard(0x25f) and c:IsType(TYPE_TRAP) and c:GetEquipTarget()
		and Duel.IsExistingTarget(c101104008.eqfilter2,0,LOCATION_MZONE,LOCATION_MZONE,1,c:GetEquipTarget(),c,tp)
end
function c101104008.eqfilter2(c,ec,tp)
	return c:IsFaceup() and (c:IsSetCard(0x25e) or not c:IsControler(tp)) and ec:CheckEquipTarget(c)
end
function c101104008.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c101104008.eqfilter1,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c101104008.eqfilter1,tp,LOCATION_SZONE,0,1,1,nil)
	local tc=g1:GetFirst()
	e:SetLabelObject(tc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g2=Duel.SelectTarget(tp,c101104008.eqfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc:GetEquipTarget(),tc,tp)
end
function c101104008.eqop(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==ec then tc=g:GetNext() end
	if ec:IsFaceup() and ec:IsRelateToEffect(e) and ec:CheckEquipTarget(tc) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Equip(tp,ec,tc)
	end
end
