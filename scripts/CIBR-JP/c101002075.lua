--メタファイズ・ディメンション
--Metaphys Dimension
--Scripted by Eerie Code
function c101002075.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101002075.target)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101002075,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c101002075.spcon)
	e2:SetCost(c101002075.spcost)
	e2:SetTarget(c101002075.sptg)
	e2:SetOperation(c101002075.spop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101002075,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c101002075.rmcon)
	e3:SetCost(c101002075.rmcost)
	e3:SetTarget(c101002075.rmtg)
	e3:SetOperation(c101002075.rmop)
	c:RegisterEffect(e3)
end
function c101002075.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS,true)
	if res and c101002075.spcon(e,tp,teg,tep,tev,tre,tr,trp)
		and c101002075.spcost(e,tp,teg,tep,tev,tre,tr,trp,0)
		and c101002075.sptg(e,tp,teg,tep,tev,tre,tr,trp,0)
		and Duel.SelectYesNo(tp,94) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		c101002075.spcost(e,tp,teg,tep,tev,tre,tr,trp,1)
		c101002075.sptg(e,tp,teg,tep,tev,tre,tr,trp,1)
		e:SetOperation(c101002075.spop)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c101002075.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function c101002075.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,101002075)==0 end
	Duel.RegisterFlagEffect(tp,101002075,RESET_PHASE+PHASE_END,0,1)
end
function c101002075.spfilter(c,e,tp)
	return c:IsFaceup() and (c:IsCode(89189982,36898537) or c:IsSetCard(0x202))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101002075.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c101002075.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101002075.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101002075.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101002075.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		tc:RegisterFlagEffect(101002075,RESET_EVENT+0x1fe0000,0,1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetLabel(Duel.GetTurnCount()+1)
		e2:SetLabelObject(tc)
		e2:SetCondition(c101002075.ermcon)
		e2:SetOperation(c101002075.ermop)
		Duel.RegisterEffect(e2,tp)
	end
end
function c101002075.ermcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(101002075)~=0 then
		return Duel.GetTurnCount()==e:GetLabel()
	else
		e:Reset()
		return false
	end
end
function c101002075.ermop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end
function c101002075.rmcfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
		and (c:IsCode(89189982,36898537) or c:IsSetCard(0x202))
end
function c101002075.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c101002075.rmcfilter,1,e:GetHandler(),tp)
end
function c101002075.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,101002075+100)==0 end
	Duel.RegisterFlagEffect(tp,101002075+100,RESET_PHASE+PHASE_END,0,1)
end
function c101002075.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c101002075.rmop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
