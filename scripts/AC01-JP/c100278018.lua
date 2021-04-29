
--花騎士団の駿馬
--Script by XyLeN
function c100278018.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100278018,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,100278018)
	e1:SetTarget(c100278018.thtg)
	e1:SetOperation(c100278018.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--fusion proc
	local e3=aux.AddFusionEffectProcUltimate(c,{
		mat_location=LOCATION_MZONE+LOCATION_HAND,
		include_this_card=true,
		reg=false
	})
	e3:SetDescription(aux.Stringid(100278018,1))
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e3)
end
function c100278018.thfilter(c)
	return c:IsSetCard(0x107a) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToHand()
end
function c100278018.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100278018.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100278018.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100278018.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
