--EMラフメイカー
--Performapal Laughmaker
--Scripted by Eerie Code
function c100911004.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100911004,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1)
	e1:SetCondition(c100911004.rccon)
	e1:SetTarget(c100911004.rctg)
	e1:SetOperation(c100911004.rcop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100911004,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCountLimit(1,100911004)
	e2:SetCondition(c100911004.atkcon)
	e2:SetOperation(c100911004.atkop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100911004,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,100911004)
	e3:SetCondition(c100911004.spcon)
	e3:SetTarget(c100911004.sptg)
	e3:SetOperation(c100911004.spop)
	c:RegisterEffect(e3)
end
function c100911004.rcfilter(c)
	return c:IsFaceup() and c:GetAttack()>c:GetBaseAttack()
end
function c100911004.rccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100911004.rcfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c100911004.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c100911004.rcop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c100911004.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return c100911004.rcfilter(e:GetHandler()) or Duel.IsExistingMatchingCard(c100911004.rcfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c100911004.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToBattle() or c:IsFacedown() then return end
	local ct=Duel.GetMatchingGroupCount(c100911004.rcfilter,tp,0,LOCATION_MZONE,nil)
	if c100911004.rcfilter(c) then ct=ct+1 end
	if ct>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000*ct)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		c:RegisterEffect(e1)
	end
end
function c100911004.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousAttackOnField()>c:GetBaseAttack()
end
function c100911004.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp)
		and chkc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingTarget(Card.IsCanBeSpecialSummoned,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,Card.IsCanBeSpecialSummoned,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100911004.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
