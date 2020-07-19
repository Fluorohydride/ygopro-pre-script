--鉄獣の戦線
--
--Script by JustFish
function c101102052.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c101102052.splimit)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101102052,0))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,101102052)
	e3:SetCost(c101102052.srcost)
	e3:SetTarget(c101102052.srtg)
	e3:SetOperation(c101102052.srop)
	c:RegisterEffect(e3)
	--attacklimit
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101102052,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c101102052.limcon)
	e4:SetOperation(c101102052.limop)
	c:RegisterEffect(e4)
end
function c101102052.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsRace(RACE_BEAST+RACE_BEASTWARRIOR+RACE_WINDBEAST)
end
function c101102052.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c101102052.srfilter,tp,LOCATION_DECK,0,1,nil,c:GetOriginalRace())
end
function c101102052.srfilter(c,race)
	return c:IsSetCard(0x24f) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:GetOriginalRace()~=race
end
function c101102052.srcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c101102052.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c101102052.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp)
	end
	local g=Duel.SelectMatchingCard(tp,c101102052.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
	e:SetLabel(g:GetFirst():GetOriginalRace())
	Duel.SendtoGrave(g,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101102052.srop(e,tp,eg,ep,ev,re,r,rp)
	local race=e:GetLabel()
	if race==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101102052.srfilter,tp,LOCATION_DECK,0,1,1,nil,race)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101102052.limcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsReason(REASON_EFFECT) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_SZONE)
		and Duel.GetTurnPlayer()==1-tp and aux.bpcon()
end
function c101102052.limop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
