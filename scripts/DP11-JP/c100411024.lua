--闇薔薇の妖精
--Dark Rose Fairy
--Scripted by AlphaKretin
function c100411024.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100411024,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,100411024)
	e1:SetCondition(c100411024.spcon)
	e1:SetTarget(c100411024.sptg)
	e1:SetOperation(c100411024.spop)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100411024,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100411024+100)
	e2:SetCost(c100411024.tdcost)
	e2:SetTarget(c100411024.tdtg)
	e2:SetOperation(c100411024.tdop)
	c:RegisterEffect(e2)
end
function c100411024.spfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TUNER)
end
function c100411024.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100411024.spfilter,1,nil)
end
function c100411024.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100411024.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100411024.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c100411024.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c100411024.tdop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local opt=Duel.SelectOption(tp,aux.Stringid(100411024,2),aux.Stringid(100411024,3))
		Duel.SendtoDeck(e:GetHandler(),nil,opt,REASON_EFFECT)
	end
end
