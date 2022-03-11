--白銀の城の狂時計
--
--Script by Trishula9
function c100418020.initial_effect(c)
	--Trap activate in set turn
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100418020)
	e1:SetCost(c100418020.cost)
	e1:SetOperation(c100418020.operation)
	c:RegisterEffect(e1)
	--to hand or spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,100418020+100)
	e2:SetCondition(c100418020.tscon)
	e2:SetTarget(c100418020.tstg)
	e2:SetOperation(c100418020.tsop)
	c:RegisterEffect(e2)
end
function c100418020.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c100418020.filter(c)
	return c:IsSetCard(0x280) and c:IsFaceup()
end
function c100418020.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100418020.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c100418020.acttg(e,c)
	return c:GetType()==TYPE_TRAP
end
function c100418020.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetCountLimit(1)
	e1:SetCondition(c100418020.actcon)
	e1:SetTarget(c100418020.acttg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c100418020.cfilter(c,tp,re,r,rp)
	if not c:IsPreviousLocation(LOCATION_HAND) or rp~=tp or not re then return end
	local rc=re:GetHandler()
	return (rc:IsSetCard(0x280) and not rc:IsCode(100418020)) or (re:IsActiveType(TYPE_TRAP) and rc:GetType()==TYPE_TRAP)
end
function c100418020.tscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100418020.cfilter,1,nil,tp,re,r,rp) and not eg:IsContains(e:GetHandler())
end
function c100418020.tstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand()
		or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100418020.tsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local b1=c:IsAbleToHand()
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local op=0
	if b1 and not b2 then
		op=Duel.SelectOption(tp,1190)
	end
	if not b1 and b2 then
		op=Duel.SelectOption(tp,1152)+1
	end
	if b1 and b2 then
		op=Duel.SelectOption(tp,1190,1152)
	end
	if op==0 then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
	if op==1 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end