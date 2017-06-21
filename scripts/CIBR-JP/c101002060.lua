--アシンメタファイズ
--Asymmetaphys
--Scripted by Eerie Code
function c101002060.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--discard and draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101002060,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c101002060.drtg)
	e2:SetOperation(c101002060.drop)
	c:RegisterEffect(e2)
	--reduce stats
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101002060,1))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_REMOVE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c101002060.atkcon)
	e3:SetOperation(c101002060.atkop)
	c:RegisterEffect(e3)
	--position
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(101002060,2))
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetCondition(c101002060.poscon)
	e4:SetTarget(c101002060.postg)
	e4:SetOperation(c101002060.posop)
	c:RegisterEffect(e4)
end
function c101002060.drfilter(c)
	return (c:IsCode(89189982,36898537) or c:IsSetCard(0x202)) and c:IsAbleToRemove()
end
function c101002060.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c101002060.drfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101002060.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101002060.drfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
		Duel.Draw(p,d,REASON_EFFECT)
	end
end
function c101002060.effilter(c,tp)
	return c:IsFaceup() and (c:IsCode(89189982,36898537) or c:IsSetCard(0x202)) and c:IsControler(tp)
end
function c101002060.effcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c101002060.effilter,1,nil,tp)
end
function c101002060.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return c101002060.effcon(e,tp,eg,ep,ev,re,r,rp) and Duel.GetTurnPlayer()==tp
end
function c101002060.filter(c)
	return c:IsFaceup() and not (c:IsCode(89189982,36898537) or c:IsSetCard(0x202))
end
function c101002060.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c101002060.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(-500)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end
function c101002060.poscon(e,tp,eg,ep,ev,re,r,rp)
	return c101002060.effcon(e,tp,eg,ep,ev,re,r,rp) and Duel.GetTurnPlayer()~=tp
end
function c101002060.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c101002060.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c101002060.posop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local sg=Duel.GetMatchingGroup(c101002060.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if sg:GetCount()>0 then
		Duel.ChangePosition(sg,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end
