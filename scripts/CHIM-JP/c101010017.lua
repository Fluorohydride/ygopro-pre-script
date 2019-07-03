--芳香法师-月桂叶
function c101010017.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101010017,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101010017)
	e1:SetCondition(c101010017.spcon)
	e1:SetTarget(c101010017.sptg)
	e1:SetOperation(c101010017.spop)
	c:RegisterEffect(e1)
	--become tuner
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101010017,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_RECOVER)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,101010017+100)
	e2:SetCondition(c101010017.btcon)
	e2:SetTarget(c101010017.bttg)
	e2:SetOperation(c101010017.btop)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101010017,2))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,101010017+200)
	e3:SetTarget(c101010017.rctg)
	e3:SetOperation(c101010017.rcop)
	c:RegisterEffect(e3)
end
function c101010017.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON+RACE_PLANT) and c:IsType(TYPE_TUNER)
end
function c101010017.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp) > Duel.GetLP(1-tp)
end
function c101010017.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101010017.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c101010017.btcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c101010017.btfilter(c)
	return c:IsRace(RACE_PLANT) and (not c:IsType(TYPE_TUNER))
end
function c101010017.bttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c101010017.btfilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c101010017.btfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
function c101010017.btop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e1)
	end
end
function c101010017.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c101010017.rcop(e,tp,eg,ep,ev,re,r,rp)
	local _,__,___,p,d = Duel.GetOperationInfo(0,CATEGORY_RECOVER)
	Duel.Recover(p,d,REASON_EFFECT)
end