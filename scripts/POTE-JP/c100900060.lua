--壹世坏-佩鲁利诺
function c100900060.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100900060+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c100900060.activate)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c100900060.atktg)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60470713,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,100900060+100)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetCondition(c100900060.descon)
	e3:SetTarget(c100900060.destg)
	e3:SetOperation(c100900060.desop)
	c:RegisterEffect(e3)
end

function c100900060.filter(c)
	return ((c:IsSetCard(0x284) and c:IsType(TYPE_MONSTER)) or c:IsCode(56099748)) and c:IsAbleToHand()
end
function c100900060.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100900060.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(56063182,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c100900060.atktg(e,c)
	return c:IsType(TYPE_FUSION) or c:IsSetCard(0x284)
end
function c100900060.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousControler(tp)
		and (c:IsPreviousLocation(LOCATION_GRAVE) or (c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)))
		and c:IsSetCard(0x284)
end
function c100900060.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100900060.cfilter,1,nil,tp)
end
function c100900060.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c100900060.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c100900060.mfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x71) and c:IsRace(RACE_FAIRY)
end
function c100900060.filter(c,e,tp,chk)
	return c:IsSetCard(0x284) and c:IsType(TYPE_MONSTER)
		and (c:IsAbleToHand() or chk and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK))
end
function c100900060.operation(e,tp,eg,ep,ev,re,r,rp)
	local b=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c100900060.mfilter,tp,LOCATION_MZONE,0,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100900060.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,b)
	local tc=g:GetFirst()
	if tc then
		if b and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end