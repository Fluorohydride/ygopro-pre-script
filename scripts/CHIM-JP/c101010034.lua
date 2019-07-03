--芳香炽天使-墨角兰
function c101010034.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--92266279 28265983 101010074
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101010034,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,101010034)
	e1:SetCondition(c101010034.spcon)
	e1:SetTarget(c101010034.sptg)
	e1:SetOperation(c101010034.spop)
	c:RegisterEffect(e1)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c101010034.immtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--remove grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101010034,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_RECOVER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,101010034+100)
	e3:SetCondition(c101010034.descon)
	e3:SetTarget(c101010034.destg)
	e3:SetOperation(c101010034.desop)
	c:RegisterEffect(e3)
end
function c101010034.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c101010034.spfilter(c)
	return c:IsCode(92266279,28265983,101010074) and c:IsAbleToHand()
end
function c101010034.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010034.spfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101010034.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c101010034.spfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,tp,REASON_EFFECT)
		end
	end
end
function c101010034.immtg(e,c)
	local p = c:GetControler()
	return Duel.GetLP(p) > Duel.GetLP(1-p) and c:IsRace(RACE_PLANT)
end
function c101010034.descon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c101010034.desfilter(c)
	return c:IsSetCard(0xc9) and c:IsFaceup()
end
function c101010034.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return i>0 and Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c101010034.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFirstTarget()
	if g:IsRelateToEffect(e) then
		Duel.Destroy(g,REASON_EFFECT)
	end
end