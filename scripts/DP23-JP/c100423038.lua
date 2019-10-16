--フューチャー・ドライブ

--Scripted by mallu11
function c100423038.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,100423038+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100423038.target)
	e1:SetOperation(c100423038.activate)
	c:RegisterEffect(e1)
end
function c100423038.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x207f)
end
function c100423038.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100423038.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100423038.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c100423038.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c100423038.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(tp)) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetOperation(c100423038.disop)
	tc:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e3:SetTarget(c100423038.distg)
	tc:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_DISABLE_EFFECT)
	tc:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e5:SetCondition(aux.bdocon)
	e5:SetOperation(c100423038.damop)
	tc:RegisterEffect(e5)
end
function c100423038.disop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if not bc then return end
	bc:RegisterFlagEffect(100423038,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE,0,1)
end
function c100423038.distg(e,c)
	return c:GetFlagEffect(100423038)~=0
end
function c100423038.damop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if not bc then return end
	local dam=bc:GetBaseAttack()
	if dam<0 then dam=0 end
	Duel.Damage(1-tp,dam,REASON_EFFECT)
end
