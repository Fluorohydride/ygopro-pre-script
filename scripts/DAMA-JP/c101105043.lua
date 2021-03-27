--弩級軍貫－いくら型一番艦
--Dreadnought Suship – Roe-class First Wardish
--scripted by XyleN5967
function c101105043.initial_effect(c)
	--xyz procedure
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--apply the effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101105043,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,101105043)
	e1:SetCondition(c101105043.effcon)
	e1:SetTarget(c101105043.efftg)
	e1:SetOperation(c101105043.effop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101105043,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c101105043.descon)
	e2:SetTarget(c101105043.destg)
	e2:SetOperation(c101105043.desop)
	c:RegisterEffect(e2)
end
function c101105043.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c101105043.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local chk1=c:GetMaterial():FilterCount(Card.IsCode,nil,101105011)>0
	local chk2=c:GetMaterial():FilterCount(Card.IsCode,nil,101105012)>0
	if chk==0 then return (chk1 and Duel.IsPlayerCanDraw(tp,1) or chk2) end
	if chk1 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function c101105043.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chk1=c:GetMaterial():FilterCount(Card.IsCode,nil,101105011)>0
	local chk2=c:GetMaterial():FilterCount(Card.IsCode,nil,101105012)>0
	if chk1 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if chk2 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function c101105043.descon(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	return ep~=tp and rc:IsControler(tp) and rc:IsSetCard(0x267) and rc:IsSummonLocation(LOCATION_EXTRA)
end
function c101105043.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101105043.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
