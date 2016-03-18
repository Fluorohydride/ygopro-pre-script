--曲芸の魔術師
--Acrobat Magician
--ygohack137-13790925
function c100909009.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCountLimit(1,100909009)
	e1:SetCondition(c100909009.spcon)
	e1:SetTarget(c100909009.sptg)
	e1:SetOperation(c100909009.pspop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c100909009.pentg)
	e2:SetOperation(c100909009.penop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAIN_NEGATED)
	e3:SetRange(LOCATION_HAND)
	e3:SetTarget(c100909009.sptg)
	e3:SetOperation(c100909009.spop)
	c:RegisterEffect(e3)
end
function c100909009.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp
		and c:IsReason(REASON_EFFECT)
end
function c100909009.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100909009.cfilter,1,nil,tp)
end
function c100909009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100909009.pspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
	elseif Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		Duel.SendtoGrave(c,REASON_RULE)
 	end
end
function c100909009.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7)
	if chk==0 then return b1 end
end
function c100909009.penop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7)
	if b1 and e:GetHandler():IsRelateToEffect(e) then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c100909009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100909009.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
	elseif Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		Duel.SendtoGrave(c,REASON_RULE)
 	end
end
