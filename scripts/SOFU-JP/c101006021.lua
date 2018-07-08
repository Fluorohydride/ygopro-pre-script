--雷獣龍－サンダー・ドラゴン
--Beastial Thunder Dragon
--Script by dest
function c101006021.initial_effect(c)
	--recycle
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101006021,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101006021)
	e1:SetCost(c101006021.cost)
	e1:SetTarget(c101006021.target)
	e1:SetOperation(c101006021.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101006021,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,101006021)
	e2:SetTarget(c101006021.sptg)
	e2:SetOperation(c101006021.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c101006021.spcon)
	c:RegisterEffect(e3)
end
function c101006021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c101006021.filter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsSetCard(0x222) and not c:IsCode(101006021) and c:IsAbleToHand()
end
function c101006021.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c101006021.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c101006021.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101006021.filter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101006021.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c101006021.spfilter(c,e,tp)
	return c:IsSetCard(0x222) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c101006021.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101006021.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101006021.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c101006021.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local fid=e:GetHandler():GetFieldID()
		tc:RegisterFlagEffect(101006021,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetCondition(c101006021.thcon)
		e1:SetOperation(c101006021.thop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c101006021.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(101006021)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c101006021.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetLabelObject(),nil,REASON_EFFECT)
end
