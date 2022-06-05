--アマゾネス拝謁の間
--Amazoness Hall
--scripted by Yuzurisa
function c100290038.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_END_PHASE)
	e1:SetTarget(c100290038.target)
	e1:SetOperation(c100290038.activate)
	c:RegisterEffect(e1)

	e2:SetDescription(aux.Stringid(100290038,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,100290038)
	e2:SetCondition(c100290038.lpcond)
	e2:SetTarget(c100290038.lptg)
	e2:SetOperation(c100290038.lpop)
	c:RegisterEffect(e2)
end

function c100290038.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c100290038.CheckPendulumZones(tp)
	return Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1)
end
function c100290038.pendfilter(c,tp)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c100290038.CheckPendulumZones(tp)
end
function c100290038.cfilter(c,tp)
	return c:IsMonster() and c:IsSetCard(0x4) and c:IsFaceup() and (c:IsAbleToHand() or c100290038.pendfilter(c,tp))
end
function c100290038.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100290038.cfilter),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil,tp)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(100290038,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=g:Select(tp,1,1,nil)
		local toHandFlag=tc:IsAbleToHand()
		local toPendFlag=c100290038.CheckPendulumZones(tp)
		if toHandFlag and (not toPendFlag and Duel.SelectOption(tp,1190,1160)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
function c100290038.amzfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4) and c:IsOriginalType(TYPE_MONSTER)
end
function c100290038.lpcond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100290038.amzfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c100290038.lpfilter(c,e,tp)
	return c:IsControler(1-tp) and c:IsFaceup() and c:GetAttack()>0 and c:IsCanBeEffectTarget(e)
		and c:IsLocation(LOCATION_MZONE)
end
function c100290038.lptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c100290038.lpfilter(chkc,e,tp) end
	if chk==0 then return eg:IsExists(c100290038.lpfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=eg:FilterSelect(tp,c100290038.lpfilter,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetAttack())
end
function c100290038.lpop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local value=tc:GetAttack()
		if value==0 then return end
		Duel.Recover(tp,value,REASON_EFFECT)
	end
end
