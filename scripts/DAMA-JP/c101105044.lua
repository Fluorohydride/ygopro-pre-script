--先史遺産ヴィマナ
--
--Script by JustFish
function c101105044.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101105044,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c101105044.atktg)
	e1:SetOperation(c101105044.atkop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101105044,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c101105044.discon)
	e2:SetCost(c101105044.discost)
	e2:SetTarget(c101105044.distg)
	e2:SetOperation(c101105044.disop)
	c:RegisterEffect(e2)
end
function c101105044.atkfilter(c)
	return (c:IsSetCard(0x70) or c:IsType(TYPE_XYZ)) and c:IsType(TYPE_MONSTER) and c:GetAttack()>0
end
function c101105044.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.IsExistingTarget(c101105044.atkfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	e:SetLabelObject(g:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101105044.atkfilter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c101105044.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sc=g:GetFirst()
	if sc==tc then sc=g:GetNext() end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or not sc:IsRelateToEffect(e) then return end
	local ac=e:GetLabelObject()
	if tc==ac then tc=sc end
	local atk=tc:GetAttack()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(math.ceil(atk/2))
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	ac:RegisterEffect(e1)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Overlay(e:GetHandler(),tc)
	end
end
function c101105044.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_MONSTER)
end
function c101105044.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c101105044.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c101105044.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end