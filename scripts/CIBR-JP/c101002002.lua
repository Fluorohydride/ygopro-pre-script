--コンデンサー・デスストーカー
--Condenser Death Stalker
--Scripted by Sahim
function c101002002.initial_effect(c)
	--ATK up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101002002,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c101002002.atktg)
	e1:SetOperation(c101002002.atkop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101002002,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,101002002)
	e2:SetCondition(c101002002.condition)
	e2:SetTarget(c101002002.target)
	e2:SetOperation(c101002002.operation)
	c:RegisterEffect(e2)
end
function c101002002.atkfil(c)
	return c:IsFaceup() and c:IsRace(RACE_CYBERS)
end
function c101002002.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc:IsFaceup() and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c101002002.atkfil,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c101002002.atkfil,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
end
function c101002002.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetTarget(function (e,c) return c==tc end)
		e1:SetValue(800)
		c:RegisterEffect(e1)
	end
end
function c101002002.condition(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,0x41)==0x41 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c101002002.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,800)
end
function c101002002.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(tp,800,REASON_EFFECT)
	Duel.Damage(1-tp,800,REASON_EFFECT)
end
