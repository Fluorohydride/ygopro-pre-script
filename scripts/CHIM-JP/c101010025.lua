--燎星のプロメテオロン

--Scripted by nekrozar
function c101010025.initial_effect(c)
	--extra attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101010025,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(c101010025.atcon)
	e1:SetCost(c101010025.atcost)
	e1:SetOperation(c101010025.atop)
	c:RegisterEffect(e1)
end
function c101010025.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if not bc then return false end
	local seq=bc:GetPreviousSequence()
	e:SetLabel(seq+16)
	return Duel.GetAttacker()==e:GetHandler() and aux.bdocon(e,tp,eg,ep,ev,re,r,rp) and seq<5 and e:GetHandler():IsChainAttackable(0)
end
function c101010025.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_DISCARD+REASON_COST)
end
function c101010025.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetLabel(e:GetLabel())
	e1:SetOperation(c101010025.disop)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function c101010025.disop(e,tp)
	return bit.lshift(0x1,e:GetLabel())
end
