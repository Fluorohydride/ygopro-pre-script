--竜魔導の守護者
--Keeper of Dragonian Magic
--Scripted by Eerie Code
function c100200143.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100200143,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,100200143)
	e1:SetCost(c100200143.thcost)
	e1:SetTarget(c100200143.thtg)
	e1:SetOperation(c100200143.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100200143,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,100200143+100)
	e3:SetCost(c100200143.spcost)
	e3:SetTarget(c100200143.sptg)
	e3:SetOperation(c100200143.spop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(100200143,ACTIVITY_SPSUMMON,c100200143.counterfilter)
end
function c100200143.counterfilter(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA or c:IsType(TYPE_FUSION)
end
function c100200143.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(100200143,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c100200143.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c100200143.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_FUSION) and c:IsLocation(LOCATION_EXTRA)
end
function c100200143.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
		and c100200143.cost(e,tp,eg,ep,ev,re,r,rp,0) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	c100200143.cost(e,tp,eg,ep,ev,re,r,rp,1)
end
function c100200143.thfilter(c)
	return c:GetType()==TYPE_SPELL and c:IsSetCard(0x46) and c:IsAbleToHand()
end
function c100200143.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100200143.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100200143.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100200143.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100200143.filter1(c,e,tp)
	return c.material and Duel.IsExistingMatchingCard(c100200143.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function c100200143.filter2(c,e,tp,fc)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and c:IsCode(table.unpack(fc.material))
end
function c100200143.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c100200143.cost(e,tp,eg,ep,ev,re,r,rp,0)
		and Duel.IsExistingMatchingCard(c100200143.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c100200143.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.ConfirmCards(1-tp,g)
	e:SetLabelObject(g:GetFirst())
	c100200143.cost(e,tp,eg,ep,ev,re,r,rp,1)
end
function c100200143.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c100200143.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local fc=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100200143.filter2),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,fc)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,g)
	end
end
