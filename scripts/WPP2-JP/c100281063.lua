--切り裂かれし闇
--
--Scripted by KillerDJ
function c100281063.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100281063,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,100281063)
	e2:SetCondition(c100281063.drcon)
	e2:SetTarget(c100281063.drtg)
	e2:SetOperation(c100281063.drop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--atk up
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100281063,1))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,100281063+100)
	e4:SetCondition(c100281063.atkcon)
	e4:SetOperation(c100281063.atkop)
	c:RegisterEffect(e4)
end
----------------------
function c100281063.cfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL) and c:IsSummonPlayer(tp) and not c:IsType(TYPE_TOKEN)
end
function c100281063.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100281063.cfilter,1,nil,tp)
end
function c100281063.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c100281063.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
----------------------
function c100281063.mtfilter(c)
	return c:IsFusionType(TYPE_NORMAL) or c:IsSynchroType(TYPE_NORMAL) or c:IsXyzType(TYPE_NORMAL)
end
function c100281063.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	local g1=a:GetMaterial()
	local g2=at:GetMaterial()
	return at and ((a:IsControler(tp) 
		and ((a:IsType(TYPE_NORMAL) and a:IsLevelAbove(5)) 
		or (a:IsType(TYPE_RITUAL) and g1:IsExists(Card.IsType,1,nil,TYPE_NORMAL)) 
		or (a:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) and g1:IsExists(c100281063.mtfilter,1,nil))))
		or (at:IsControler(tp) and at:IsFaceup() 
		and ((at:IsType(TYPE_NORMAL) and at:IsLevelAbove(5))
		or (at:IsType(TYPE_RITUAL) and g2:IsExists(Card.IsType,1,nil,TYPE_NORMAL)) 
		or (at:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) and g2:IsExists(c100281063.mtfilter,1,nil)))))
end
function c100281063.atkop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	if a:IsControler(1-tp) then a,at=at,a end
	if not a:IsRelateToBattle() or a:IsFacedown() or not at:IsRelateToBattle() or at:IsFacedown() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(at:GetAttack())
	a:RegisterEffect(e1)
end











