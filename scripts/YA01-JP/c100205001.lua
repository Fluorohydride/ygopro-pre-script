--オッドアイズ・ファントム・ドラゴン
--Odd-Eyes Phantom Dragon
--Script by mercury233
function c100205001.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetDescription(aux.Stringid(100205001,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCountLimit(1,100205001)
	e1:SetCondition(c100205001.damcon)
	e1:SetTarget(c100205001.damtg)
	e1:SetOperation(c100205001.damop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c100205001.atkcon)
	e2:SetTarget(c100205001.atktg)
	e2:SetOperation(c100205001.atkop)
	c:RegisterEffect(e2)
end
function c100205001.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM
		and Duel.GetAttacker()==e:GetHandler()
end
function c100205001.damfilter(c)
	return c:IsFaceup() and (c:GetSequence()==6 or c:GetSequence()==7) and c:IsSetCard(0x99)
end
function c100205001.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c100205001.damfilter,tp,LOCATION_SZONE,0,nil)
	if chk==0 then return ct>0 end
	Duel.SetTargetParam(ct*1200)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*1200)
end
function c100205001.damop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c100205001.damfilter,tp,LOCATION_SZONE,0,nil)
	Duel.Damage(1-tp,ct*1200,REASON_EFFECT)
end
function c100205001.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
	if tc and tc:IsSetCard(0x99) then
		local a=Duel.GetAttacker()
		local d=Duel.GetAttackTarget()
		if d and a:GetControler()~=d:GetControler() then
			if a:IsControler(tp) and a:IsFaceup() then e:SetLabelObject(a)
			elseif d:IsFaceup() then e:SetLabelObject(d)
			else return false end
			return true
		else return false end
	else return false end
end
function c100205001.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if chk==0 then return tc:IsOnField() end
	Duel.SetTargetCard(tc)
end
function c100205001.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1200)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		tc:RegisterEffect(e1)
	end
end
