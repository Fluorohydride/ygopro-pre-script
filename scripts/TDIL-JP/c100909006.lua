--ＥＭバブルドッグ
--Performapal Bubbulldog
--Scripted by Eerie Code
function c100909006.initial_effect(c)
  --pendulum summon
	aux.EnablePendulumAttribute(c)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(c100909006.reptg)
	e2:SetValue(c100909006.repval)
	e2:SetOperation(c100909006.repop)
	c:RegisterEffect(e2)
	--Indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c100909006.con)
	e3:SetOperation(c100909006.op)
	c:RegisterEffect(e3)
end

function c100909006.filter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and not c:IsType(TYPE_PENDULUM) and c:GetSummonLocation()==LOCATION_EXTRA and not c:IsReason(REASON_REPLACE)
end
function c100909006.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c100909006.filter,1,nil,tp) and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) end
	return Duel.SelectYesNo(tp,aux.Stringid(100909006,0))
end
function c100909006.repval(e,c)
	return c100909006.filter(c,e:GetHandlerPlayer())
end
function c100909006.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end

function c100909006.con(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  return c:IsPreviousLocation(LOCATION_EXTRA)
end
function c100909006.op(e,tp,eg,ep,ev,re,r,rp)
  local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c100909006.indtg)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetValue(1)
	Duel.RegisterEffect(e2,tp)
end
function c100909006.indtg(e,c)
	return c:IsType(TYPE_PENDULUM) and c:GetSummonLocation()==LOCATION_EXTRA
end
