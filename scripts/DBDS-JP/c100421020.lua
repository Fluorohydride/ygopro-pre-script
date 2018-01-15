-- 空牙団の孤高 サジータ　
-- Sajita, Solitary of the Skyfang Brigade
function c100421020.initial_effect(c)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100421020,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,100421020)
	e3:SetTarget(c100421020.damtg)
	e3:SetOperation(c100421020.damop)
	c:RegisterEffect(e3)
	--untargetable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c14541657.atlimit)
	c:RegisterEffect(e1)
	
end
function c100421020.damfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x214) and c:IsType(TYPE_MONSTER)
end
function c100421020.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100421020.damfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c100421020.damfilter,tp,LOCATION_MZONE,0,nil)
	local val=g:GetClassCount(Card.GetCode)*500
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,val)
end
function c100421020.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c100421020.damfilter,tp,LOCATION_MZONE,0,nil)
	local val=g:GetClassCount(Card.GetCode)*500
	Duel.Damage(p,val,REASON_EFFECT)
end
function c14541657.atlimit(e,c)
	return c:IsFaceup() and c:IsSetCard(0x214) and c~=e:GetHandler()
end