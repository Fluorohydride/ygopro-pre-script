--鏡の御巫ニニ
--
--Script by Trishula9
function c100419026.initial_effect(c)
	--no damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c100419026.ndcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--battle indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	e2:SetCondition(c100419026.indcon)
	c:RegisterEffect(e2)
	--reflect battle damage
	local e3=e2:Clone()
	e3:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	c:RegisterEffect(e3)
	--control
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_CONTROL)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e4:SetCountLimit(1,100419026)
	e4:SetCondition(c100419026.ctcon)
	e4:SetTarget(c100419026.cttg)
	e4:SetOperation(c100419026.ctop)
	c:RegisterEffect(e4)
end
function c100419026.ndcon(e)
	return e:GetHandler():GetEquipCount()==0
end
function c100419026.indcon(e)
	return e:GetHandler():GetEquipCount()>0
end
function c100419026.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipCount()>0 and Duel.GetTurnPlayer()==1-tp
end
function c100419026.filter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c100419026.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c100419026.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100419026.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c100419026.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c100419026.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp,PHASE_END,1)
	end
end