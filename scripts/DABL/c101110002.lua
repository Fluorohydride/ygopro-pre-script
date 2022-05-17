--黑羽-岚砂之沙马鲁
function c101110002.initial_effect(c)
	--- has dragon in content
	aux.AddCodeList(c, 9012916)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101110002,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,101110002)
	e1:SetCost(c101110002.tscost)
	e1:SetTarget(c101110002.tstg)
	e1:SetOperation(c101110002.tsop)
	c:RegisterEffect(e1)

	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101110002,1))
	e2:SetCategory(CATEGORY_TOHAND + CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101110102)
	e2:SetCondition(c101110002.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101110002.thtg)
	e2:SetOperation(c101110002.thop)
	c:RegisterEffect(e2)
end

function c101110002.tscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c101110002.tsfilter(c)
	return c:IsCode(101110052) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end

function c101110002.tstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(c101110002.tsfilter,tp,LOCATION_DECK,0,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	end
end

function c101110002.tsop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c101110002.tsfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()

	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end


function c101110002.thconfilter(c,tp)
	local isRightCode = (c:IsSetCard(0x33) and c:IsType(TYPE_SYNCHRO)) or c:IsCode(9012916)
	return c:IsControler(tp) and isRightCode
end

function c101110002.thtgfilter(c)
	return c:IsSetCard(0x33) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function c101110002.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101110002.thconfilter,1,nil,tp) 
end
function c101110002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then 
		return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c101110002.thtgfilter(chkc) 
	end

	if chk==0 then
		return Duel.IsExistingTarget(c101110002.thtgfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) 
	end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c101110002.thtgfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_GRAVE)
end

function c101110002.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SendtoHand(tc,nil,REASON_EFFECT) > 0 then
			Duel.BreakEffect()
			Duel.Damage(tp,700,REASON_EFFECT)
		end 
	end
end