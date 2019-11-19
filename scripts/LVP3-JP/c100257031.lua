--X・HERO ヘル・デバイサー

--Scripted by mallu11
function c100257031.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x8),2,2)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100257031,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,100257031)
	e1:SetCondition(c100257031.thcon)
	e1:SetCost(c100257031.thcost)
	e1:SetTarget(c100257031.thtg)
	e1:SetOperation(c100257031.thop)
	c:RegisterEffect(e1)
	--atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c100257031.atktg)
	e2:SetValue(c100257031.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(100257031,ACTIVITY_SPSUMMON,c100257031.counterfilter)
end
function c100257031.counterfilter(c)
	return c:IsSetCard(0x8)
end
function c100257031.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c100257031.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(100257031,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c100257031.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c100257031.splimit(e,c)
	return not c:IsSetCard(0x8)
end
function c100257031.ffilter(c,tp)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x8)
		and Duel.IsExistingMatchingCard(c100257031.thfilter,tp,LOCATION_DECK,0,1,nil,c)
end
function c100257031.thfilter(c,fc)
	return aux.IsMaterialListCode(fc,c:GetCode()) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c100257031.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100257031.ffilter,tp,LOCATION_EXTRA,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end
function c100257031.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,c100257031.ffilter,tp,LOCATION_EXTRA,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.GetMatchingGroup(c100257031.thfilter,tp,LOCATION_DECK,0,nil,tc)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,2)
		if sg and sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c100257031.atktg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsRace(RACE_FIEND)
end
function c100257031.atkval(e,c)
	return c:GetLevel()*100
end
