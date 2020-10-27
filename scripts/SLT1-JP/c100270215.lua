--圣蔓之治愈者
function c100270215.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c100270215.mfilter,1,1)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100270215,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c100270215.descon)
	e1:SetTarget(c100270215.destg)
	e1:SetOperation(c100270215.desop)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100270215,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c100270215.rectg)
	e2:SetOperation(c100270215.recop)
	c:RegisterEffect(e2)
	--Recover by battle
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100270215,2))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c100270215.recon)
	e3:SetTarget(c100270215.retg)
	e3:SetOperation(c100270215.reop)
	c:RegisterEffect(e3)
end
function c100270215.mfilter(c)
	return c:IsLinkType(TYPE_NORMAL) and c:IsLinkRace(RACE_PLANT)
end
function c100270215.cfilter(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and c:IsReason(REASON_EFFECT)
		and bit.band(c:GetPreviousTypeOnField(),TYPE_LINK)~=0 and c:IsPreviousSetCard(0x256) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c100270215.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100270215.cfilter,1,nil,tp)
end
function c100270215.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c100270215.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c100270215.recfilter(c)
	return c:IsSetCard(0x256) and c:IsType(TYPE_LINK) and c:IsLinkAbove(1)
end
function c100270215.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c100270215.recfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100270215.recfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c100270215.recfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetLink()*300)
end
function c100270215.recop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetLink()>0 then
		Duel.Recover(tp,tc:GetLink()*300,REASON_EFFECT)
	end
end
function c100270215.recon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return ep~=tp and tc:IsControler(tp) and tc:IsType(TYPE_LINK) and tc:IsRace(RACE_PLANT)
end
function c100270215.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(600)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,600)
end
function c100270215.reop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end