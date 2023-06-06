--Combat Wheel
--Scripted by: CVen00/ToonyBirb using modified outline originally created by XGlitchy30
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon.  used c91397409 (Penguin Brave) for reference
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()

	c:EnableCounterPermit(0x0)
	
	--effect 1: OPT, cannot be destroyed by opponent's card effects
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.indct)
	c:RegisterEffect(e1)

	--effect 2: Once per opponent BP (Quick eff) discard 1; gain half of total attack of all monsters owner controls, add a counter, and prevent other attack targets 
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCondition(s.condition2)
	e2:SetCost(s.cost2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)

	--used code from c75041269 to indicate whether this card meets conditions for effect 3
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_LEAVE_FIELD_P)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetOperation(s.regop)
	c:RegisterEffect(e0)

	--effect 3: If destroyed by battle with a counter on it, destroy all monsters owner controls
	local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(s.condition3)
	e3:SetTarget(s.target3)
	e3:SetOperation(s.operation3)
	e3:SetLabelObject(e0)
	c:RegisterEffect(e3)
end

--effect 1:  Referenced c86578200
function s.indct(e,re,r,rp)
	if bit.band(r,REASON_EFFECT)~=0 and e:GetOwnerPlayer()~=rp then
		return 1
	else return 0 end
end

--effect 2

--condition to check if it is the battle phase.  Used part of the condtional from c98585345 (Winged Kuriboh LV10)
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end

--used code from c42566602
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end

--used target function from c64276752
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,e:GetHandler()):GetSum(Card.GetBaseAttack)>0 end
end



--used code from c61380658 and c91740879 and modified it to fit effect
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message('test')
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then 
		local atk=(Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,c):GetSum(Card.GetBaseAttack))/2
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(atk)
		c:RegisterEffect(e1)

		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTargetRange(0,LOCATION_MZONE)
		e2:SetValue(s.atlimit)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)

		if Duel.IsCanAddCounter(tp,0x0,1,c) then c:AddCounter(0x0,1) end


	end

end


--used this function from c61380658 (Watthopper), and modified it to fit the effect
function s.atlimit(e,c)
	return c~=e:GetHandler()
end


--effect 0.  used code from c75041269
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	--Debug.Message('entered label function')
	if e:GetHandler():GetCounter(0x0)>=1 then
		--Debug.Message('setting label to 1')
		e:SetLabel(1)
	else
		--Debug.Message('setting label to 0')
		e:SetLabel(0)
	end
end


--effect 3

--used code from c75041269 and modified it to fit naming conventions
function s.condition3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return e:GetHandler():IsReason(REASON_DESTROY) and e:GetLabelObject():GetLabel()==1
end

--Used code from c12580477 (Raigeki) and modified to fit effect
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	--Debug.Message(Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil))
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end