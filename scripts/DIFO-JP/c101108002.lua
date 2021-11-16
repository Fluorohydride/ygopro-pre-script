--EMレディアンジュ
--
--Script by Trishula9
function c101108002.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--atk down
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101108002,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c101108002.atkcon)
	e1:SetCost(c101108002.atkcost)
	e1:SetOperation(c101108002.atkop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101108002,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1,101108002)
	e2:SetCost(c101108002.drcost)
	e2:SetTarget(c101108002.drtg)
	e2:SetOperation(c101108002.drop)
	c:RegisterEffect(e2)
	--pendulum set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101108002,2))
	e3:SetCategory(CATEGORY_LEAVE_GRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,101108002)
	e3:SetCondition(c101108002.pencon)
	e3:SetTarget(c101108002.pentg)
	e3:SetOperation(c101108002.penop)
	c:RegisterEffect(e3)
end
function c101108002.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a,d=Duel.GetBattleMonster(tp)
	return a and d and d:IsFaceup()
end
function c101108002.costfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsDiscardable()
end
function c101108002.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101108002.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c101108002.costfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c101108002.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetBattleMonster(1-tp)
	if tc and tc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c101108002.drfilter(c)
	return c:IsSetCard(0x9f) and c:IsType(TYPE_MONSTER) and not c:IsCode(101108002) and c:IsDiscardable()
end
function c101108002.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() and Duel.IsExistingMatchingCard(c101108002.drfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c101108002.drfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c101108002.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c101108002.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c101108002.penfilter(c)
	return (c:IsSetCard(0x99) or c:IsCode(101108001)) and c:IsFaceup()
end
function c101108002.pencon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101108002.penfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c101108002.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c101108002.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
