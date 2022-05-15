--黑羽-岚砂之夏马尔
function c101110003.initial_effect(c)
	aux.AddCodeList(c,9012916)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101110003,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,101110003)
	e1:SetCost(c101110003.tfcost)
	e1:SetTarget(c101110003.tftg)
	e1:SetOperation(c101110003.tfop)
	c:RegisterEffect(e1)  
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101110003,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101110004)
	e2:SetCondition(c101110003.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101110003.thtg)
	e2:SetOperation(c101110003.thop)
	c:RegisterEffect(e2)	 
end
function c101110003.tfcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c101110003.tffilter(c,tp)
	return c:IsCode(101110052)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c101110003.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c101110003.tffilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c101110003.tfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c101110003.tffilter),tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c101110003.cfilter(c,tp)
	return c:IsFaceup() and ((c:IsSetCard(0x33) and c:IsType(TYPE_SYNCHRO)) or c:IsCode(9012916)) and c:IsControler(tp)
end
function c101110003.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101110003.cfilter,1,nil,tp)
end
function c101110003.thfilter(c)
	return c:IsSetCard(0x33) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c101110003.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101110003.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101110003.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101110003.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,700)
end
function c101110003.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		Duel.Damage(tp,700,REASON_EFFECT)
	end
end