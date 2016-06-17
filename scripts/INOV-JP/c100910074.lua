--PSYフレーム・アクセラレーター
--PSY-Frame Accelerator
--Script by nekrozar
function c100910074.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100910074,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100910074.target1)
	e1:SetOperation(c100910074.operation)
	c:RegisterEffect(e1)
	--Activate(special summon)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100910074,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c100910074.spcon)
	e2:SetCost(c100910074.spcost)
	e2:SetTarget(c100910074.sptg1)
	e2:SetOperation(c100910074.spop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100910074,2))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetCost(c100910074.cost)
	e3:SetTarget(c100910074.target2)
	e3:SetOperation(c100910074.operation)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100910074,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c100910074.spcon)
	e4:SetCost(c100910074.spcost)
	e4:SetTarget(c100910074.sptg2)
	e4:SetOperation(c100910074.spop)
	c:RegisterEffect(e4)
end
function c100910074.rmfilter(c)
	return c:IsSetCard(0xc1) and c:IsAbleToRemove()
end
function c100910074.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100910074.rmfilter(chkc) end
	if chk==0 then return true end
	if e:GetHandler():GetFlagEffect(100910074)==0 and Duel.CheckLPCost(tp,500)
		and Duel.IsExistingTarget(c100910074.rmfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.SelectYesNo(tp,94) then
		e:SetCategory(CATEGORY_REMOVE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:GetHandler():RegisterFlagEffect(100910074,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		Duel.PayLPCost(tp,500)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectTarget(tp,c100910074.rmfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	else
		e:SetCategory(0)
		e:SetProperty(0)
	end
end
function c100910074.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500)
		and e:GetHandler():GetFlagEffect(100910074)==0 end
	Duel.PayLPCost(tp,500)
	e:GetHandler():RegisterFlagEffect(100910074,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c100910074.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c100910074.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100910074.rmfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c100910074.rmfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c100910074.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(100910074)==0 or not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local ct=1
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then ct=2 end
		local fid=c:GetFieldID()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c100910074.retcon)
		e1:SetOperation(c100910074.retop)
		if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
			e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
			e1:SetValue(Duel.GetTurnCount())
		else
			e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
			e1:SetValue(0)
		end
		Duel.RegisterEffect(e1,tp)
		tc:RegisterFlagEffect(100910274,RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,ct,fid)
	end
end
function c100910074.retfilter(c,fid)
	return c:GetFlagEffectLabel(100910274)==fid
end
function c100910074.retcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp or Duel.GetTurnCount()==e:GetValue() then return false end
	local g=e:GetLabelObject()
	if not g:IsExists(c100910074.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c100910074.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c100910074.retfilter,nil,e:GetLabel())
	g:DeleteGroup()
	local tc=sg:GetFirst()
	while tc do
		if tc:IsForbidden() then 
			Duel.SendtoGrave(tc,REASON_RULE)
		else
			Duel.ReturnToField(tc)
		end
		tc=sg:GetNext()
	end
end
function c100910074.cfilter(c,tp)
	return c:IsPreviousSetCard(0xc1) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp
end
function c100910074.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100910074.cfilter,1,e:GetHandler(),tp)
end
function c100910074.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(100910174)==0 end
	e:GetHandler():RegisterFlagEffect(100910174,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c100910074.spfilter(c,e,tp)
	return c:IsSetCard(0xc1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100910074.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100910074.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c100910074.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100910074.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c100910074.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100910074.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
