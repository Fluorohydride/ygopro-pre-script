--めぐり-Ai-
--When A.I. First Met You
--Scripted by Kohana Sonogami
function c101104060.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101104060+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c101104060.target)
	e1:SetOperation(c101104060.activate)
	c:RegisterEffect(e1)
end
function c101104060.chkfilter(c,tp)
	return c:IsRace(RACE_CYBERSE) and c:GetAttack()==2300 and not c:IsPublic()
		and Duel.IsExistingMatchingCard(c101104060.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetAttribute())
end
function c101104060.thfilter(c,att)
	return c:IsSetCard(0x135) and c:IsAttribute(att) and c:IsAbleToHand()
end
function c101104060.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101104060.chkfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101104060.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local rc=Duel.SelectMatchingCard(tp,c101104060.chkfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,tp)
	e:SetLabel(rc:GetFirst():GetAttribute())
	Duel.ConfirmCards(1-tp,rc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetLabel(rc:GetFirst():GetCode())
	e1:SetOperation(c101104060.regop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetCondition(c101104060.damcon)
	e2:SetOperation(c101104060.damop)
	e2:SetLabelObject(e1)
	Duel.RegisterEffect(e2,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101104060.thfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c101104060.splimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c101104060.regop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then return end
	local tc=eg:GetFirst()
	if tc:IsCode(e:GetLabel()) then
		e:SetLabel(0)
	end
end
function c101104060.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()~=0
end
function c101104060.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(tp,2300,REASON_EFFECT)
end
function c101104060.splimit(e,c)
	return not c:IsRace(RACE_CYBERSE)
end
