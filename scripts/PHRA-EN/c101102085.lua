--Myutant ST-46
function c101102085.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101102085,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101102085)
	e1:SetCost(c101102085.thcost)
	e1:SetTarget(c101102085.thtg)
	e1:SetOperation(c101102085.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101102085,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101102085+100)
	e3:SetCost(c101102085.spcost)
	e3:SetTarget(c101102085.sptg)
	e3:SetOperation(c101102085.spop)
	c:RegisterEffect(e3)
end
function c101102085.thfilter(c)
	return c:IsSetCard(0x258) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and c:GetCode()~=101102085
end
function c101102085.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101102085.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101102085.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101102085.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101102085.spcostexcheckfilter(c,e,tp,code)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(code)
end
function c101102085.spcostexcheck(c,e,tp)
	local result=false
	if c:IsType(TYPE_MONSTER) then
		result=result or Duel.IsExistingMatchingCard(c101102085.spcostexcheckfilter,tp,LOCATION_DECK+LOCATION_HAND,e,tp,101102087)
	end
	if c:IsType(TYPE_SPELL) then
		result=result or Duel.IsExistingMatchingCard(c101102085.spcostexcheckfilter,tp,LOCATION_DECK+LOCATION_HAND,e,tp,101102088)
	end
	if c:IsType(TYPE_TRAP) then
		result=result or Duel.IsExistingMatchingCard(c101102085.spcostexcheckfilter,tp,LOCATION_DECK+LOCATION_HAND,e,tp,101102089)
	end
	return result
end
function c101102085.spcostfilter(c,e,tp,tg)
	tg:AddCard(c)
	return c:IsAbleToRemoveAsCost() and c101102085.spcostexcheck(c,e,tp)
		and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
		and Duel.GetMZoneCount(tp,tg)>0
end
function c101102085.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		e:SetLabel(1)
		return Duel.IsExistingMatchingCard(c101102085.spcostfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler(),e,tp,e:GetHandler())
			and e:GetHandler():IsReleasable()
	end
	Duel.Release(e:GetHandler(),REASON_COST+REASON_RELEASE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cost=Duel.SelectMatchingCard(tp,c101102085.spcostfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,e,tp)
	e:SetLabel(cost:GetType())
	Duel.Remove(cost,POS_FACEUP,REASON_COST)
end
function c101102085.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local label=e:GetLabel()
		if label>0 then
			e:SetLabel(0)
			return true
		end
		return false
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101102085.spopfilter(c,e,tp,typ)
	return (((typ & TYPE_MONSTER)>0 and c:IsCode(101102087))
		or ((typ & TYPE_SPELL)>0 and c:IsCode(101102088))
		or ((typ & TYPE_TRAP)>0 and c:IsCode(101102089)))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101102085.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	local typ = e:GetLabel()
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c101102085.spopfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp,typ)
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end