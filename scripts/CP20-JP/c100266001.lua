--暗黑之魔再生
function c100266001.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c100266001.condition)
	e1:SetTarget(c100266001.target)
	e1:SetOperation(c100266001.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100266001,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c100266001.spcost)
	e2:SetTarget(c100266001.sptg)
	e2:SetOperation(c100266001.spop)
	c:RegisterEffect(e2)
end
function c100266001.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c100266001.filter(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsSSetable() and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
end
function c100266001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and c100266001.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c100266001.filter,tp,0,LOCATION_GRAVE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c100266001.filter,tp,0,LOCATION_GRAVE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,#g,0,0)
end
function c100266001.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SSet(tp,tc,tp)
	end
end
function c100266001.spcfilter(c)
	return c:IsCode(83764718) and c:IsAbleToGraveAsCost()
		and (c:IsFacedown() or c:IsLocation(LOCATION_HAND))
end
function c100266001.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100266001.spcfilter,tp,LOCATION_SZONE+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100266001.spcfilter,tp,LOCATION_SZONE+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c100266001.sptgfilter(c,e,tp)
	return c:IsCode(10000010) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c100266001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100266001.sptgfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c100266001.tgfilter(c,e,tp)
	return c:IsAbleToGrave()
end
function c100266001.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c100266001.sptgfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)>0
		and Duel.IsExistingMatchingCard(c100266001.tgfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(100266001,0)) then
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(100266001,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c100266001.tgcon)
		e1:SetOperation(c100266001.tgop)
		Duel.RegisterEffect(e1,tp)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c100266001.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c100266001.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(100266001)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c100266001.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetLabelObject(),REASON_EFFECT)
end