--龍狸燈
--
--Script by JoyJ
function c101101035.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101101035,0))
	e1:SetCategory(CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c101101035.defcost)
	e1:SetOperation(c101101035.defop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetCountLimit(1)
	e2:SetCondition(c101101035.atkcon)
	e2:SetOperation(c101101035.atkop)
	c:RegisterEffect(e2)
end
function c101101035.defcostfilter(c)
	return c:IsDiscardable() and c:IsRace(RACE_WYRM)
end
function c101101035.defcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101101035.defcostfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c101101035.defcostfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c101101035.defop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c101101035.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	return bc and (ac==c or bc==c)
		and ac:IsPosition(POS_ATTACK)
		and bc:IsPosition(POS_ATTACK)
end
function c101101035.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:IsRelateToBattle() and d and d:IsRelateToBattle() then
		local ea=Effect.CreateEffect(c)
		ea:SetType(EFFECT_TYPE_SINGLE)
		if EFFECT_SET_BATTLE_ATTACK then
			ea:SetCode(EFFECT_SET_BATTLE_ATTACK)
		else
			ea:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
			ea:SetCode(EFFECT_SET_ATTACK_FINAL)	
			ea:SetRange(LOCATION_MZONE)
		end
		ea:SetReset(RESET_PHASE+PHASE_DAMAGE)
		ea:SetValue(a:GetDefense())
		a:RegisterEffect(ea,true)
		local ed=Effect.CreateEffect(c)
		ed:SetType(EFFECT_TYPE_SINGLE)
		if EFFECT_SET_BATTLE_ATTACK then
			ed:SetCode(EFFECT_SET_BATTLE_ATTACK)
		else
			ed:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
			ed:SetCode(EFFECT_SET_ATTACK_FINAL)
			ed:SetRange(LOCATION_MZONE)
		end
		ed:SetReset(RESET_PHASE+PHASE_DAMAGE)
		ed:SetValue(d:GetDefense())
		d:RegisterEffect(ed,true)
	end
end
