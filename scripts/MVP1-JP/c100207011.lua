--クリスタル・アバター
--Krystal Avatar
--Script by dest
function c100207011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c100207011.condition)
	e1:SetTarget(c100207011.target)
	e1:SetOperation(c100207011.activate)
	c:RegisterEffect(e1)
end
function c100207011.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c100207011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local at=Duel.GetAttacker()
	local atk=Duel.GetLP(tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		Duel.IsPlayerCanSpecialSummonMonster(tp,100207011,0,0x21,atk,0,4,RACE_WARRIOR,ATTRIBUTE_LIGHT)
		and at:IsOnField() and at:GetAttack()>=atk end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100207011.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local atk=Duel.GetLP(tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,100207011,0,0x21,atk,0,4,RACE_WARRIOR,ATTRIBUTE_LIGHT) then return end
	c:AddTrapMonsterAttribute(TYPE_EFFECT,ATTRIBUTE_LIGHT,RACE_WARRIOR,4,atk,0)
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_ATTACK)
	c:TrapMonsterBlock()
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100207011,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLED)
	e1:SetLabel(atk)
	e1:SetCondition(c100207011.damcon)
	e1:SetTarget(c100207011.damtg)
	e1:SetOperation(c100207011.damop)
	e1:SetReset(RESET_EVENT+0x17e0000)
	c:RegisterEffect(e1)
	local at=Duel.GetAttacker()
	if at and at:IsAttackable() and at:IsFaceup() and not at:IsImmuneToEffect(e) and not at:IsStatus(STATUS_ATTACK_CANCELED) then
		Duel.BreakEffect()
		Duel.ChangeAttackTarget(c)
	end
end
function c100207011.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c100207011.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=e:GetLabel()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c100207011.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
