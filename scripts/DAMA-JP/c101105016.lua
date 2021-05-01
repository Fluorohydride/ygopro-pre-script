--機巧鳥－常世宇受賣長鳴
--
--Script by XyleN5967
function c101105016.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101105016,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101105016)
	e1:SetCost(c101105016.spcost)
	e1:SetTarget(c101105016.sptg)
	e1:SetOperation(c101105016.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101105016,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetCountLimit(1,101105016+100)
	e2:SetTarget(c101105016.thtg)
	e2:SetOperation(c101105016.thop)
	c:RegisterEffect(e2)
end
function c101105016.costfilter(c,e,tp)
	return aux.AtkEqualsDef(c) and c:IsRace(RACE_MACHINE) and c:GetLevel()>1
		and Duel.GetMZoneCount(tp,c)>0 and (c:IsControler(tp) or c:IsFaceup())
		and Duel.IsExistingMatchingCard(c101105016.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetLevel())
end
function c101105016.spfilter(c,e,tp,lv)
	return aux.AtkEqualsDef(c) and c:IsRace(RACE_MACHINE)
		and c:GetLevel()<lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101105016.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101105016.costfilter,1,nil,e,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c101105016.costfilter,1,1,nil,e,tp)
	e:SetLabel(sg:GetFirst():GetLevel())
	Duel.Release(sg,REASON_COST)
end
function c101105016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101105016.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101105016.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,e:GetLabel())
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101105016.thfilter(c)
	return c:IsFacedown() and aux.AtkEqualsDef(c)
		and c:IsRace(RACE_MACHINE) and c:IsAbleToHand()
end
function c101105016.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101105016.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c101105016.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101105016.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
