--影六武衆－キザル
--Shadow Six Samurai – Kizaru
--Scripted by Eerie Code
function c100419005.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100419005,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c100419005.thtg)
	e1:SetOperation(c100419005.thop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c100419005.reptg)
	e2:SetValue(c100419005.repval)
	e2:SetOperation(c100419005.repop)
	c:RegisterEffect(e2)
end
function c100419005.filter(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c100419005.thfilter(c,tp)
	return c:IsSetCard(0x3d) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
		and not Duel.IsExistingMatchingCard(c100419005.filter,tp,LOCATION_MZONE,0,1,nil,c:GetAttribute())
end
function c100419005.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100419005.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100419005.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100419005.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100419005.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3d)
		and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsReason(REASON_EFFECT)
end
function c100419005.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c100419005.repfilter,1,nil,tp)
		and eg:GetCount()==1 end
	return Duel.SelectYesNo(tp,aux.Stringid(100419005,1))
end
function c100419005.repval(e,c)
	return c100419005.repfilter(c,e:GetHandlerPlayer())
end
function c100419005.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
