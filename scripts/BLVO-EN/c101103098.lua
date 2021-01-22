--War Rock Ordeal
--Scripted by Kohana Sonogami
function c101103098.initial_effect(c)
	c:EnableCounterPermit(0x61,LOCATION_SZONE)
	c:SetUniqueOnField(1,0,101103098)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c101103098.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101103098,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c101103098.drcost)
	e2:SetTarget(c101103098.drtg)
	e2:SetOperation(c101103098.drop)
	c:RegisterEffect(e2)
end
function c101103098.activate(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x61,3)
end
function c101103098.drcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return at:IsControler(tp) and at:IsFaceup() and at:IsSetCard(0x263)
end
function c101103098.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c101103098.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then
			e:SetLabel(0)
			return Duel.IsPlayerCanDraw(tp,1) and e:GetHandler():IsCanRemoveCounter(tp,0x61,1,REASON_COST)
		else return false end
	end
	e:SetLabel(0)
	e:GetHandler():RemoveCounter(tp,0x61,1,REASON_COST)
	if e:GetHandler():GetCounter(0x61)==0 then
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101103098.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
