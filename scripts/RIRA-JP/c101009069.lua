--海晶少女潮流
function c101009069.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetTarget(c101009069.target)
	e1:SetOperation(c101009069.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c101009069.handcon)
	c:RegisterEffect(e2)
end
function c101009069.afilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x22b) and c:IsType(TYPE_LINK)
end
function c101009069.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x22b) and c:IsLinkAbove(2)
end
function c101009069.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c101009069.afilter,1,nil,tp) end
	local a=eg:Filter(c101009069.afilter,nil,tp):GetFirst()
	local dam=a:GetLink()
	if chk==0 then return dam>0 end
	Duel.SetTargetCard(a)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam*400)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam*400)
end
function c101009069.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local bc=tc:GetBattleTarget()
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local dam=tc:GetLink()
	if dam<0 then dam=0 end
	Duel.Damage(p,dam*400,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(c101009068.cfilter,tp,LOCATION_MZONE,0,1,nil) and bc:IsType(TYPE_LINK) then
		Duel.Damage(1-tp,500,REASON_EFFECT,true)
	end
end
function c101009069.handfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x22b) and c:IsLinkAbove(2)
end
function c101009069.handcon(e)
	return Duel.IsExistingMatchingCard(c101009069.handfilter,tp,LOCATION_MZONE,0,1,nil)
end