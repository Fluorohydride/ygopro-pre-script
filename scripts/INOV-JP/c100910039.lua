--フルメタルフォーゼ・アルカエスト
--Fullmetalfoes Alkahest
--Script by nekrozar
--Effect is not fully implemented
function c100910039.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xe1),aux.FilterBoolFunction(Card.IsType,TYPE_NORMAL),true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100910039,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c100910039.eqcon)
	e2:SetTarget(c100910039.eqtg)
	e2:SetOperation(c100910039.eqop)
	c:RegisterEffect(e2)
end
function c100910039.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c100910039.eqfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsAbleToChangeControler()
end
function c100910039.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c100910039.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c100910039.eqfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c100910039.eqfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c100910039.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsType(TYPE_EFFECT)) then return end
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		if Duel.Equip(tp,tc,c)==0 then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_EQUIP_LIMIT)
		e2:SetValue(c100910039.eqlimit)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		tc:RegisterFlagEffect(100910039,RESET_EVENT+0x1fe0000,0,1)
	else Duel.SendtoGrave(tc,REASON_EFFECT) end
end
function c100910039.eqlimit(e,c)
	return e:GetOwner()==c
end
