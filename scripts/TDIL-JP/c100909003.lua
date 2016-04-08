--EMエクストラ・シューター
--Performapal Extra Shooter
--Scripted by Eerie Code
function c100909003.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--Damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100909003,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,100909003)
	e1:SetCondition(c100909003.dmcon)
	e1:SetCost(c100909003.dmcost)
	e1:SetTarget(c100909003.dmtg)
	e1:SetOperation(c100909003.dmop)
	c:RegisterEffect(e1)
	--Destroy & Damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100909003,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCost(c100909003.descost)
	e2:SetTarget(c100909003.destg)
	e2:SetOperation(c100909003.desop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(100909003,ACTIVITY_SPSUMMON,c100909003.counterfilter)
end
function c100909003.counterfilter(c)
	return not bit.band(c:GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c100909003.dmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c100909003.dmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(100909003,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c100909003.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c100909003.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c100909003.dmfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c100909003.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100909003.dmfilter,tp,LOCATION_EXTRA,0,1,nil) end
	local dam=Duel.GetMatchingGroupCount(c100909003.dmfilter,tp,LOCATION_EXTRA,0,nil)*300
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c100909003.dmop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local d=Duel.GetMatchingGroupCount(c100909003.dmfilter,tp,LOCATION_EXTRA,0,nil)*300
	Duel.Damage(p,d,REASON_EFFECT)
end
function c100909003.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c100909003.desfilter(c)
	return (c:GetSequence()==6 or c:GetSequence()==7) and c:IsDestructable()
end
function c100909003.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c100909003.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100909003.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c100909003.desfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300)
end
function c100909003.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Damage(1-tp,300,REASON_EFFECT)
	end
end
