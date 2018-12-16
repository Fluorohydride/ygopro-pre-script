--SRビーダマシーン
--
--Script by mercury233
function c100238007.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--on attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c100238007.condition)
	e1:SetTarget(c100238007.target)
	e1:SetOperation(c100238007.opetation)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100238007,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,100238007)
	e2:SetTarget(c100238007.thtg)
	e2:SetOperation(c100238007.thop)
	c:RegisterEffect(e2)
end
function c100238007.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return at and at:IsControler(tp) and at:IsPosition(POS_DEFENSE)
end
function c100238007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.GetAttackTarget():CreateEffectRelation(e)
end
function c100238007.opetation(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	if at:IsRelateToEffect(e) then
		Duel.ChangePosition(at,POS_FACEUP_ATTACK)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		at:RegisterEffect(e1)
	end
end
function c100238007.thfilter(c)
	return c:IsSetCard(0x2016) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c100238007.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100238007.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100238007.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100238007.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c100238007.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c100238007.splimit(e,c,tp,sumtp,sumpos)
	return c:GetAttribute()~=ATTRIBUTE_WIND
end
