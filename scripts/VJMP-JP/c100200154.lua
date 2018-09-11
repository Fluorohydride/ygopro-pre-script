--コード・ジェネレーター
--Code Generator
--Script by mercury233
function c100200154.initial_effect(c)
	--hand link
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c100200154.matcon)
	e1:SetValue(c100200154.matval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(c100200154.ctcon)
	e2:SetOperation(c100200154.ctop)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100200154,0))
	e3:SetCategory(CATEGORY_DECKDES+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,100200154)
	e3:SetCondition(c100200154.tdcon)
	e3:SetTarget(c100200154.tdtg)
	e3:SetOperation(c100200154.tdop)
	c:RegisterEffect(e3)
end
function c100200154.matcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),100200154)==0
end
function c100200154.mfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_CYBERSE)
end
function c100200154.exmfilter(c)
	return c:IsLocation(LOCATION_HAND) and c:IsCode(100200154)
end
function c100200154.matval(e,c,mg)
	return c:IsSetCard(0x101) and mg:IsExists(c100200154.mfilter,1,nil) and not mg:IsExists(c100200154.exmfilter,1,nil)
end
function c100200154.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c100200154.ctop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,100200154,RESET_PHASE+PHASE_END,0,1)
end
function c100200154.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	e:SetLabel(0)
	if c:IsPreviousLocation(LOCATION_ONFIELD) then e:SetLabel(1) end
	return c:IsLocation(LOCATION_GRAVE) and c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND) and r==REASON_LINK and c:GetReasonCard():IsSetCard(0x101)
end
function c100200154.tdfilter(c,chk)
	return c:IsRace(RACE_CYBERSE) and c:IsAttackBelow(1200) and (c:IsAbleToGrave() or (chk==1 and c:IsAbleToHand()))
end
function c100200154.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100200154.tdfilter,tp,LOCATION_DECK,0,1,nil,e:GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c100200154.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100200154.tdfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	local tc=g:GetFirst()
	if tc and tc:IsAbleToGrave() and (e:GetLabel()==0 or not tc:IsAbleToHand() or Duel.SelectOption(tp,1191,1190)==0) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	else
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
