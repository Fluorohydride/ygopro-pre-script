--ＥＭブランコブラ
--Performapal Swing Cobra
--By: HelixReactor
function c100316003.initial_effect(c)
  aux.EnablePendulumAttribute(c)
  --Mill
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_DECKDES)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_BATTLE_DAMAGE)
  e1:SetRange(LOCATION_PZONE)
  e1:SetCountLimit(1)
  e1:SetCondition(c100316003.millcon)
  e1:SetTarget(c100316003.milltg)
  e1:SetOperation(c100316003.millop)
  c:RegisterEffect(e1)
  --Direct attack
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_DIRECT_ATTACK)
  e2:SetRange(LOCATION_MZONE)
  c:RegisterEffect(e2)
  --Change position
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_POSITION)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
  e3:SetCountLimit(1)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCondition(c100316003.poscon)
  e3:SetOperation(c100316003.posop)
  c:RegisterEffect(e3)
end
function c100316003.millcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c100316003.milltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,0,0,1-tp,1)
end
function c100316003.millop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(1-tp,1,REASON_EFFECT)
end
function c100316003.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttackedCount()>0
end
function c100316003.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackPos() then Duel.ChangePosition(c,POS_FACEUP_DEFENCE) end
end
