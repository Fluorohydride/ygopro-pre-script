--シェル・ナイト
--Shell Knight
--script by lunatrix
function c100273006.initial_effect(c)
	--add/ss rock monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100273006,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCountLimit(1,100273006)
	e1:SetTarget(c100273006.thtg)
	e1:SetOperation(c100273006.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c100273006.thcon)
	c:RegisterEffect(e2)
	--burn
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100273006,1))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1)
	e1:SetTarget(c100273006.damtg)
	e1:SetOperation(c100273006.damop)
	c:RegisterEffect(e1)
end
function c100273006.filter(c,e,tp,chk)
	return c:GetLevel()==8 and c:GetRace()==RACE_ROCK and (c:IsAbleToHand() or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c100273006.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetReason()==REASON_EFFECT
end
function c100273006.gycon(c)
	return c:GetCode()==59419719
end
function c100273006.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100273006.thfilter,tp,LOCATION_DECK,0,1,nil) end
	if chk==0 then
		local g=Duel.IsExistingMatchingCard(c100273006.gycon,tp,LOCATION_GRAVE,0,1,nil)
		return Duel.IsExistingMatchingCard(c100273006.filter,tp,LOCATION_DECK,0,1,nil,e,tp,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c100273006.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.IsExistingMatchingCard(c100273006.gycon,tp,LOCATION_GRAVE,0,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local tc=Duel.SelectMatchingCard(tp,c100273006.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,g):GetFirst()
	if tc then
		if g and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
		and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(100273006,2))) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c100273006.aclimit)
	e1:SetLabelObject(tc)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c100273006.aclimit(e,re,tp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsCode(tc:GetCode())
end
function c100273006.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c100273006.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()
	if Duel.ChangePosition(c,POS_FACEUP_DEFENSE) then
		Duel.Damage(p,d,REASON_EFFECT)
	end
end
