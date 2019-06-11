--トポロジック・ゼロヴォロス
--
--Scripted by 龙骑
--not fully implemented
function c100336041.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c100336041.value)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100336041,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c100336041.rmcon)
	e3:SetTarget(c100336041.rmtg)
	e3:SetOperation(c100336041.rmop)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_REMOVE)
	e4:SetOperation(c100336041.spreg)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(100336041,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetRange(LOCATION_REMOVED)
	e5:SetCondition(c100336041.spcon)
	e5:SetTarget(c100336041.sptg)
	e5:SetOperation(c100336041.spop)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
end
function c100336041.value(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED)*200
end
function c100336041.cfilter(c,zone)
	local seq=c:GetSequence()
	if c:IsLocation(LOCATION_MZONE) then
		if c:IsControler(1) then seq=seq+16 end
	else
		seq=c:GetPreviousSequence()
		if c:GetPreviousControler()==1 then seq=seq+16 end
	end
	return bit.extract(zone,seq)~=0
end
function c100336041.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local zone=Duel.GetLinkedZone(0)+(Duel.GetLinkedZone(1)<<0x10)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c100336041.cfilter,1,nil,zone)
end
function c100336041.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c100336041.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c100336041.spreg(e,tp,eg,ep,ev,re,r,rp)
	if not re then return end
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if c:IsReason(REASON_EFFECT) and rc==c then
		e:SetLabel(Duel.GetTurnCount()+1)
		c:RegisterFlagEffect(100336041,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
	end
end
function c100336041.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()==Duel.GetTurnCount() and e:GetHandler():GetFlagEffect(100336041)>0
end
function c100336041.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	e:GetHandler():ResetFlagEffect(100336041)
end
function c100336041.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
