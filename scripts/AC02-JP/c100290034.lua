--らくがきちょう－とおせんぼ
--
--Script by Trishula9
function c100290034.initial_effect(c)
	--negate attack
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCountLimit(1,100290034)
	e1:SetCondition(c100290034.negcon)
	e1:SetOperation(c100290034.negop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100290034+100)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c100290034.thtg)
	e2:SetOperation(c100290034.thop)
	c:RegisterEffect(e2)
end
function c100290034.negcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsControler(tp) and tc:IsFaceup() and tc:IsRace(RACE_DINOSAUR)
end
function c100290034.spfilter(c,e,tp)
	return c:IsSetCard(0x1286) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100290034.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100290034.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
		local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ct>0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(100290034,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			if tc then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
				local fid=e:GetHandler():GetFieldID()
				tc:RegisterFlagEffect(100290034,RESET_EVENT+RESETS_STANDARD,0,1,fid)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetDescription(aux.Stringid(100290034,2))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
				e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e1:SetValue(1)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_PHASE+PHASE_END)
				e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e2:SetCountLimit(1)
				e2:SetLabel(fid)
				e2:SetLabelObject(tc)
				e2:SetCondition(c100290034.descon)
				e2:SetOperation(c100290034.desop)
				Duel.RegisterEffect(e2,tp)
			end
		end
	end
end
function c100290034.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(100290034)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c100290034.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
end
function c100290034.thfilter(c)
	return c:IsRace(RACE_DINOSAUR) and c:IsLevelAbove(5) and c:IsAbleToHand()
end
function c100290034.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100290034.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100290034.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100290034.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end