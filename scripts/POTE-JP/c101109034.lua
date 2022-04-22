--炎獣使いエーカ

--Scripted by mallu11
function c101109034.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101109034,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101109034)
	e1:SetTarget(c101109034.sptg)
	e1:SetOperation(c101109034.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101109034,1))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101109034+100)
	e3:SetTarget(c101109034.eqtg)
	e3:SetOperation(c101109034.eqop)
	c:RegisterEffect(e3)
end
function c101109034.spfilter(c,e,tp)
	return c:IsFaceup() and c:GetSequence()<5 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101109034.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c101109034.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c101109034.spfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101109034.spfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101109034.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101109034.eqfilter(c)
	return c:IsFaceup() and c:CheckUniqueOnField(tp,LOCATION_SZONE) and not c:IsForbidden()
end
function c101109034.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101109034.eqfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c101109034.eqfilter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c101109034.eqfilter,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c101109034.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if not Duel.Equip(tp,tc,c,false) then return end
		e:SetLabelObject(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetLabelObject(c)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c101109034.eqlimit)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(500)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
function c101109034.eqlimit(e,c)
	return c==e:GetLabelObject()
end
