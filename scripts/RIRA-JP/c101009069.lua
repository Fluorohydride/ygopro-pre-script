--海晶乙女潮流
--
--Scripted By-FW空鸽
function c101009069.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCountLimit(1,101009069+EFFECT_COUNT_CODE_OATH)
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
function c101009069.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return eg:IsExists(c101009069.afilter,1,nil,tp) end
end
function c101009069.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x22b) and c:IsLinkAbove(2)
end
function c101009069.activate(e,tp,eg,ep,ev,re,r,rp)
	local a=eg:Filter(c101009069.afilter,nil,tp):GetFirst()
	local bc=a:GetBattleTarget()
	local dam=a:GetLink()
	if dam<0 then dam=0 end
	Duel.Damage(1-tp,dam*400,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(c101009069.cfilter,tp,LOCATION_MZONE,0,1,nil) and bc:IsType(TYPE_LINK) then
		local dam1=bc:GetLink()
		Duel.BreakEffect()
		Duel.Damage(1-tp,dam1*500,REASON_EFFECT)
	end
end
function c101009069.hcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x22b) and c:IsLinkAbove(3)
end
function c101009069.handcon(e)
	return Duel.IsExistingMatchingCard(c101009069.hcfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
