--Toon Black Luster Soldier
function c100268001.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c100268001.spcon)
	e1:SetOperation(c100268001.spop)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(c100268001.dircon)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100268001,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c100268001.rmcon)
	e3:SetCost(c100268001.rmcost)
	e3:SetTarget(c100268001.rmtg)
	e3:SetOperation(c100268001.rmop)
	c:RegisterEffect(e3)
end
function c100268001.filter(c)
	return c:IsType(TYPE_TOON) and c:IsReleasable()
end
function c100268001.refilter(c,e,tp,m1,ft,fc)
	local mg=m1:Filter(c100268001.filter,fc)
	if ft>0 then
		return mg:CheckWithSumGreater(Card.GetLevel,8,1,99,fc)
	else
		return ft>-1 and mg:IsExists(c100268001.mfilterf,1,nil,tp,mg,fc)
	end
end
function c100268001.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(Card.GetLevel,8,0,99,rc)
	else return false end
end
function c100268001.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local mg1=Duel.GetMatchingGroup(c100268001.filter,tp,LOCATION_MZONE+LOCATION_HAND,0,c)
	return Duel.IsExistingMatchingCard(c100268001.refilter,tp,LOCATION_HAND,0,1,c,e,tp,mg1,ft,c)
end
function c100268001.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local mg1=Duel.GetMatchingGroup(c100268001.filter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	local mg=mg1:Filter(Card.IsReleasable,c)
	local mat=nil
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		mat=mg:SelectWithSumGreater(tp,Card.GetLevel,8,1,99,c)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		mat=mg:FilterSelect(tp,c100268001.mfilterf,1,1,nil,tp,mg,c)
		Duel.SetSelectedCard(mat)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat2=mg:SelectWithSumGreater(tp,Card.GetLevel,8,0,99,c)
		mat:Merge(mat2)
	end 
	Duel.Release(mat,REASON_COST+REASON_RELEASE)
end
function c100268001.cfilter1(c)
	return c:IsFaceup() and c:IsCode(15259703)
end
function c100268001.cfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TOON)
end
function c100268001.dircon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c100268001.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(c100268001.cfilter2,tp,0,LOCATION_MZONE,1,nil)
end
function c100268001.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100268001.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
end
function c100268001.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
end
function c100268001.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c100268001.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end