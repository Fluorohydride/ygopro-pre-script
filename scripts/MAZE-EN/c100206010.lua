--Prey of the Jirai Gumo
--scripted by JoyJ
function c100206010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100206010,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100206010)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c100206010.target)
	e1:SetOperation(c100206010.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100206010,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100206010)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c100206010.thtg)
	e2:SetOperation(c100206010.thop)
	c:RegisterEffect(e2)
end
function c100206010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local seq=e:GetHandler():GetSequence()
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_MZONE,seq) and
		Duel.IsPlayerCanSpecialSummonMonster(tp,100206010,0,TYPES_NORMAL_TRAP_MONSTER,2100,100,5,RACE_INSECT,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100206010.filter(c,tp)
	return c:IsControler(1-tp) and c:IsLocation(LOCATION_MZONE)
end
function c100206010.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	local zone=1<<seq
	if not Duel.CheckLocation(tp,LOCATION_MZONE,seq)
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,100206010,0,TYPES_NORMAL_TRAP_MONSTER,2100,100,5,RACE_INSECT,ATTRIBUTE_EARTH) then return end
	c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TRAP)
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP,zone)~=0 then
		local g=c:GetColumnGroup()
		g=g:Filter(c100206010.filter,nil,tp)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(100206010,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			g=g:Select(tp,1,1,nil)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c100206010.thfilter(c)
	return c:IsCode(25955164,62340868,98434877) and c:IsAbleToHand()
end
function c100206010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100206010.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c100206010.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100206010.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end