--H-C クレイヴソリッシュ
--
--Script by Trishula9
function c101108044.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),4,2)
	c:EnableReviveLimit()
	--atk limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c101108044.atklimit)
	c:RegisterEffect(e1)
	--atk double
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101108044)
	e2:SetCondition(c101108044.dbcon)
	e2:SetCost(c101108044.dbcost)
	e2:SetOperation(c101108044.dbop)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,101108044+100)
	e3:SetCondition(c101108044.upcon)
	e3:SetCost(c101108044.upcost)
	e3:SetTarget(c101108044.uptg)
	e3:SetOperation(c101108044.upop)
	c:RegisterEffect(e3)
end
function c101108044.atklimit(e,c)
	return c~=e:GetHandler()
end
function c101108044.dbcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c101108044.dbcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lp=Duel.GetLP(tp)
	if chk==0 then return Duel.CheckLPCost(tp,lp-500) end
	Duel.PayLPCost(tp,lp-500)
end
function c101108044.dbop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCountLimit(1)
	e1:SetOperation(c101108044.sop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101108044.sop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101108044,0))
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if not tc:IsImmuneToEffect(e) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(tc:GetAttack())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
function c101108044.upcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetBattleMonster(1-tp)
	return tc and tc:IsRelateToBattle()
end
function c101108044.upcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c101108044.uptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c101108044.upop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel:GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and not c:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(tc:GetAttack())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end