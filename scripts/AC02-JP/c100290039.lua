--アマゾネスの秘湯
--Amazoness Hot Spring
--scripted by Yuzurisa
function c100290039.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_END_PHASE)
	e1:SetTarget(c100290039.target)
	e1:SetOperation(c100290039.activate)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100290039,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,100290039)
	e2:SetCondition(c100290039.lpcond)
	e2:SetTarget(c100290039.lptg)
	e2:SetOperation(c100290039.lpop)
	c:RegisterEffect(e2)
end

function c100290039.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100290039.CheckPendulumZones(tp)
	return Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1)
end
function c100290039.pendfilter(c,tp)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c100290039.CheckPendulumZones(tp)
end
function c100290039.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x4) and (c:IsAbleToHand() or c100290039.pendfilter(c,tp))
end
function c100290039.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c100290039.cfilter,tp,LOCATION_DECK,0,nil,tp)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(100290039,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=g:Select(tp,1,1,nil)
		local toHandFlag=tc:IsAbleToHand()
		local toPendFlag=c100290039.CheckPendulumZones(tp)
		if toHandFlag and (not toPendFlag and Duel.SelectOption(tp,1190,1160)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
function c100290039.amzfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4) and c:IsOriginalType(TYPE_MONSTER)
end
function c100290039.lpcond(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.IsExistingMatchingCard(c100290039.amzfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c100290039.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function c100290039.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,ev,REASON_EFFECT)
end
