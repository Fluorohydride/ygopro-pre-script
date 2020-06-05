function c100268001.initial_effect(c)

c:EnableReviveLimit()

--special summon rule

	local e1=Effect.CreateEffect(c)

	e1:SetType(EFFECT_TYPE_FIELD)

	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)

	e1:SetCode(EFFECT_SPSUMMON_PROC)

	e1:SetRange(LOCATION_HAND)

	e1:SetCondition(c100268001.hspcon)

	e1:SetOperation(c100268001.hspop)

	c:RegisterEffect(e1)
	
		--direct attack

	local e2=Effect.CreateEffect(c)

	e2:SetType(EFFECT_TYPE_SINGLE)

	e2:SetCode(EFFECT_DIRECT_ATTACK)

	e2:SetCondition(c100268002.dircon)

	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)

	e3:SetDescription(aux.Stringid(100268001,1))
	 
	e3:SetCategory(CATEGORY_REMOVE)
	 
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	 
	e3:SetType(EFFECT_TYPE_IGNITION)
	 
	e3:SetCountLimit(1)
	 
	e3:SetRange(LOCATION_MZONE)
	 
	e3:SetCost(c100268001.rmcost)
	 
	e3:SetTarget(c100268001.rmtg)
	 
	e3:SetOperation(c100268001.rmop)

	c:RegisterEffect(e3)
	
	end
	
	function c100268001.hspfilter(c,tp)

	return c:IsType(TYPE_TOON) and Duel.GetMZoneCount(tp,c)>0

end

function c100268001.cfilter(c)

	return c:IsFaceup() and c:IsCode(15259703)

end

function c100268001.cfilter2(c)

	return c:IsFaceup() and c:IsType(TYPE_TOON)

end

function c100268001.hspcon(e,c)

	if c==nil then return true end

	local tp=c:GetControler()

	return Duel.CheckReleaseGroupEx(tp,c100268001.hspfilter,1,c,tp)

end

function c100268001.hspop(e,tp,eg,ep,ev,re,r,rp,c)

    local sg=Duel.GetReleaseGroup(tp,true):Filter(c100268001.hspfilter,c,tp)
	
    local sga=sg:SelectWithSumGreater(tp,Card.GetLevel,8,1,8)
	
    Duel.Release(sga,REASON_COST)
	
end

function c100268002.dircon(e)

	local tp=e:GetHandlerPlayer()

	return Duel.IsExistingMatchingCard(c100268002.cfilter,tp,LOCATION_ONFIELD,0,1,nil)

		and not Duel.IsExistingMatchingCard(c100268002.cfilter2,tp,0,LOCATION_MZONE,1,nil)

end

function c100268001.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)

	local c=e:GetHandler()

	if chk==0  then return c:GetAttackAnnouncedCount()==0 end
	
	if Duel.IsExistingMatchingCard(c100268002.cfilter,tp,LOCATION_ONFIELD,0,1,nil) then
	
	local e1=Effect.CreateEffect(c)

	e1:SetType(EFFECT_TYPE_SINGLE)

	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)

	e1:SetCode(EFFECT_CANNOT_ATTACK)

	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)

	c:RegisterEffect(e1,true)

	c:RegisterFlagEffect(100268001,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	
	end

end

function c100268001.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)

	if chkc then return chkc:GetLocation()==LOCATION_ONFIELD and chkc:IsAbleToRemove() end

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