--シェル・ナイト
--Shell Knight
--script by lunatrix
function c100273006.initial_effect(c)
	--burn
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100273006,0))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c100273006.damtg)
	e1:SetOperation(c100273006.damop)
	c:RegisterEffect(e1)
	--add/ss rock monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100273006,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetCountLimit(1,100273006)
	e2:SetTarget(c100273006.thtg)
	e2:SetOperation(c100273006.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c100273006.thcon)
	c:RegisterEffect(e3)
end
function c100273006.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c100273006.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsAttackPos() and c:IsRelateToEffect(e) and Duel.ChangePosition(c,POS_FACEUP_DEFENSE) then
		Duel.Damage(1-tp,500,REASON_EFFECT)
	end
end
function c100273006.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c100273006.filter(c,e,tp,check)
	return c:IsLevel(8) and c:IsRace(RACE_ROCK) and (c:IsAbleToHand() or check and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c100273006.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local check=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,59419719)
		return Duel.IsExistingMatchingCard(c100273006.filter,tp,LOCATION_DECK,0,1,nil,e,tp,check)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c100273006.thop(e,tp,eg,ep,ev,re,r,rp)
	local check=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,59419719)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,c100273006.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,check):GetFirst()
	if tc then
		if check and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
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
	e1:SetLabel(tc:GetCode())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c100273006.aclimit(e,re,tp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsCode(e:GetLabel())
end
