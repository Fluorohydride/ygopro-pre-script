--魔界劇団-ティンクル・リトルスター
--Abyss Actor - Twinkle Littlestar
--Scripted by Eerie Code
function c100212021.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c100212021.splimit)
	c:RegisterEffect(e1)
	--multiple attack (target)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100212021,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c100212021.condition)
	e2:SetTarget(c100212021.target)
	e2:SetOperation(c100212021.operation)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(c100212021.indcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--multiple attack (self)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e4:SetValue(2)
	c:RegisterEffect(e4)
end

function c100212021.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsSetCard(0x10ec) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

function c100212021.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c100212021.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x10ec) and not c:IsHasEffect(EFFECT_EXTRA_ATTACK_MONSTER)
end
function c100212021.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c85463083.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c85463083.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c85463083.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c100212021.ftarget)
	e1:SetLabel(g:GetFirst():GetFieldID())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c100212021.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c100212021.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetDescription(aux.Stringid(100212021,1))
		e1:SetValue(2)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end

function c100212021.indcon(e)
	local tp=e:GetHandler():GetControler()
	return Duel.GetTurnPlayer()==tp
end
