--DDD赦俿王デス・マキナ
--
--Script by JoyJ
function c101107044.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),10,2,c101107044.ovfilter,aux.Stringid(101107044,0))
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	c:SetUniqueOnField(1,0,101107044,LOCATION_MZONE)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101107044,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101107044)
	e1:SetTarget(c101107044.sptg)
	e1:SetOperation(c101107044.spop)
	c:RegisterEffect(e1)
	--overlay
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101107044,2))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c101107044.ovlcon)
	e2:SetTarget(c101107044.ovltg)
	e2:SetOperation(c101107044.ovlop)
	c:RegisterEffect(e2)
	--to pendulum
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101107044,3))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c101107044.pencon)
	e3:SetTarget(c101107044.pentg)
	e3:SetOperation(c101107044.penop)
	c:RegisterEffect(e3)
end
function c101107044.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x10af)
end
function c101107044.sptgfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c101107044.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetFirstMatchingCard(nil,tp,LOCATION_PZONE,0,c)
	if chk==0 then return tc and Duel.GetMZoneCount(tp)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c101107044.sptgfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101107044,4))
	local g=Duel.SelectTarget(tp,c101107044.sptgfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
end
function c101107044.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstMatchingCard(nil,tp,LOCATION_PZONE,0,c)
	local fc=Duel.GetFirstTarget()
	if not tc or Duel.GetMZoneCount(tp)<1 then return end
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		if not fc:IsRelateToEffect(e) then return end
		Duel.MoveToField(fc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c101107044.ovlcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsControler(1-tp) and rc:GetOriginalType()&TYPE_MONSTER~=0 and re:GetActivateLocation()&LOCATION_ONFIELD~=0
end
function c101107044.ovltgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xae)
end
function c101107044.ovltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if chk==0 then return c:GetFlagEffect(101107044)==0
		and (c:CheckRemoveOverlayCard(tp,2,REASON_EFFECT)
			or Duel.IsExistingMatchingCard(c101107044.ovltgfilter,tp,LOCATION_ONFIELD,0,1,nil))
		and rc:IsRelateToEffect(re) and rc:IsCanBeXyzMaterial(c) end
	c:RegisterFlagEffect(101107044,RESET_CHAIN,0,1)
end
function c101107044.ovlop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local opt1=c:IsRelateToEffect(e) and c:CheckRemoveOverlayCard(tp,2,REASON_EFFECT)
	local opt2=Duel.IsExistingMatchingCard(c101107044.ovltgfilter,tp,LOCATION_ONFIELD,0,1,nil)
	local result=0
	if not opt1 and not opt2 then return end
	if opt1 and not opt2 then result=0 end
	if opt2 and not opt1 then result=1 end
	if opt1 and opt2 then result=Duel.SelectOption(tp,aux.Stringid(101107044,5),aux.Stringid(101107044,6)) end
	if result==0 then
		result=c:RemoveOverlayCard(tp,2,2,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,c101107044.ovltgfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.HintSelection(g)
		result=Duel.Destroy(g,REASON_EFFECT)
	end
	if result>0 and c:IsRelateToEffect(e) and rc:IsRelateToEffect(re) and not rc:IsImmuneToEffect(e) then
		local og=rc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,rc)
	end
end
function c101107044.pencon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c101107044.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c101107044.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
