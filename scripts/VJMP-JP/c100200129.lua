--エッジインプ・コットン・イーター
--Edge Imp Cotton Eater
--Script by dest
function c100200129.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_FUSION))
	e1:SetValue(300)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100200129,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetCondition(c100200129.drcon)
	e2:SetTarget(c100200129.drtg)
	e2:SetOperation(c100200129.drop)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100200129,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,100200129)
	e3:SetTarget(c100200129.damtg)
	e3:SetOperation(c100200129.damop)
	c:RegisterEffect(e3)
end
function c100200129.drfilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0xad) and c:IsType(TYPE_FUSION)
		and bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c100200129.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100200129.drfilter,1,nil,tp)
end
function c100200129.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c100200129.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c100200129.damfilter(c)
	return c:IsSetCard(0xad) and c:IsType(TYPE_MONSTER)
end
function c100200129.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100200129.damfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local val=Duel.GetMatchingGroupCount(c100200129.damfilter,tp,LOCATION_GRAVE,0,nil)*200
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,val)
end
function c100200129.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local val=Duel.GetMatchingGroupCount(c100200129.damfilter,tp,LOCATION_GRAVE,0,nil)*200
	Duel.Damage(p,val,REASON_EFFECT)
end
