--獣王無塵

--Scripted by mallu11
function c101105078.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e0:SetHintTiming(TIMING_DAMAGE_STEP)
	e0:SetTarget(c101105078.target)
	c:RegisterEffect(e0)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101105078,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)	
	e1:SetCondition(c101105078.thcon)
	e1:SetTarget(c101105078.thtg)
	e1:SetOperation(c101105078.thop)
	c:RegisterEffect(e1)
end
function c101105078.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetCurrentPhase()~=PHASE_DAMAGE
	local b2=Duel.CheckEvent(EVENT_BATTLE_START) and c101105078.thcon(e,tp,eg,ep,ev,re,r,rp) and c101105078.thtg(e,tp,eg,ep,ev,re,r,rp,0)
	if chk==0 then return b1 or b2 end
	if b2 then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetOperation(c101105078.thop)
		c101105078.thtg(e,tp,eg,ep,ev,re,r,rp,1)
	else
		e:SetCategory(0)
		e:SetOperation(nil)
	end
end
function c101105078.thcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local b=Duel.GetAttackTarget()
	if not b then return false end
	if not a:IsControler(tp) then a,b=b,a end
	local lg=a:GetColumnGroup()
	if not lg:IsContains(b) then return false end
	e:SetLabelObject(a)
	return a:IsControler(tp) and a:IsRelateToBattle() and b:IsControler(1-tp) and b:IsRelateToBattle()
end
function c101105078.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=e:GetLabelObject()
	local c=e:GetHandler()
	if chk==0 then return a and a:IsAbleToHand() and Duel.GetFlagEffect(tp,101105078)==0 and c:GetFlagEffect(101105178)==0 end
	Duel.RegisterFlagEffect(tp,101105078,RESET_CHAIN,0,1)
	c:RegisterFlagEffect(101105178,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	local g=a:GetColumnGroup():Filter(Card.IsAbleToHand,nil)
	g:AddCard(a)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function c101105078.thop(e,tp,eg,ep,ev,re,r,rp)
	local a=e:GetLabelObject()
	if a and a:IsRelateToBattle() and a:IsControler(tp) then
		local g=a:GetColumnGroup()
		g:AddCard(a)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end
