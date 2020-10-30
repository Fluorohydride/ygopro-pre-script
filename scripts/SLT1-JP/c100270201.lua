--神星之影 路径灵
--"Lua By REIKAI 2404873791"
function c100270201.initial_effect(c)
   --flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100270201,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,100270201)
	e1:SetTarget(c100270201.target)
	e1:SetOperation(c100270201.operation)
	c:RegisterEffect(e1)
	--CANNOT ACT
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100270201,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,100270201)
	e2:SetCondition(c100270201.spcon)
	e2:SetTarget(c100270201.sptg)
	e2:SetOperation(c100270201.spop)
	c:RegisterEffect(e2) 
end
function c100270201.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x9d)
end
function c100270201.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c100270201.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100270201.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c100270201.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c100270201.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(c100270201.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c100270201.efilter(e,re)
	return e:GetHandler()~=re:GetOwner() and re:IsActiveType(TYPE_MONSTER)
end
function c100270201.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c100270201.tfilter2_1(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c100270201.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c100270201.tfilter2_1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,c100270201.tfilter2_1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil) 
end
function c100270201.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e2_1_1=Effect.CreateEffect(c)
		e2_1_1:SetType(EFFECT_TYPE_SINGLE)
		e2_1_1:SetCode(EFFECT_CANNOT_TRIGGER)
		e2_1_1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2_1_1)
	end
end