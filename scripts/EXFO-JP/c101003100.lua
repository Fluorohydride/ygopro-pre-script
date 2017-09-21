--電送擬人エレキネシス
--Electronic Transimulation Wattkinesis
--Scripted by Eerie Code
function c101003100.initial_effect(c)
	--move
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c101003100.seqcost)
	e2:SetTarget(c101003100.seqtg)
	e2:SetOperation(c101003100.seqop)
	c:RegisterEffect(e2)
end
function c101003100.seqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c101003100.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil)
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101003100,0))
	Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
end
function c101003100.seqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(tp) then return end
	local seq=tc:GetSequence()
	local flag=0
	for i=0,4 do
		if Duel.CheckLocation(1-tp,LOCATION_MZONE,i) then flag=bit.bor(flag,math.pow(2,i)) end
	end
	if flag==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,571)
	local s=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,flag)
	local nseq=math.sqrt(s)
	Duel.MoveSequence(tc,nseq)
end
