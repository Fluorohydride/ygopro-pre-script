--Laughing Puffin the Jester Bird
--Scripted by: XGlitchy30

function c101110033.initial_effect(c)
	--SS
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101110033,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101110033)
	e1:SetCondition(c101110033.spcon)
	e1:SetTarget(c101110033.sptg)
	e1:SetOperation(c101110033.spop)
	c:RegisterEffect(e1)
	--bounce
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101110033,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,80275708)
	e2:SetLabel(0)
	e2:SetCondition(c101110033.handle_effect_type)
	e2:SetCost(c101110033.thcost)
	e2:SetTarget(c101110033.thtg)
	e2:SetOperation(c101110033.thop)
	c:RegisterEffect(e2)
	local e2x=e2:Clone()
	e2x:SetType(EFFECT_TYPE_QUICK_O)
	e2x:SetCode(EVENT_FREE_CHAIN)
	e2x:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_END_PHASE)
	c:RegisterEffect(e2x)
end
function c101110033.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c101110033.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101110033.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c101110033.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
end
function c101110033.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToChain(0) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c101110033.excfilter(c)
	return c:IsFacedown() or not c:IsRace(RACE_WINDBEAST)
end
function c101110033.handle_effect_type(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local res = #g>0 and not g:IsExists(c101110033.excfilter,1,nil)
	if e:IsHasType(EFFECT_TYPE_IGNITION) then
		return not res
	else
		return res
	end
end
function c101110033.costfilter(c,tp)
	return c:IsRace(RACE_WINDBEAST) and Duel.IsExistingTarget(c101110033.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function c101110033.thfilter(c,e)
	return c101110033.cfilter(c) and c:IsAbleToHand()
end
function c101110033.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101110033.costfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c101110033.costfilter,1,1,nil,tp)
	if #g>0 then
		Duel.Release(g,REASON_COST)
	end
end
function c101110033.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c101110033.thfilter(chkc) end
	if chk==0 then
		local res = e:GetLabel()==1 or Duel.IsExistingTarget(c101110033.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		e:SetLabel(0)
		return res
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c101110033.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function c101110033.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToChain(0) and tc:IsFaceup() and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetLabel(tc:GetCode())
		e1:SetValue(c101110033.aclimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c101110033.aclimit(e,re)
	return re:GetHandler():IsCode(e:GetLabel())
end