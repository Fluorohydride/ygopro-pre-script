--アマゾネス拝謁の間
--
--Script by Trishula9
function c100290038.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c100290038.activate)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100290038,3))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,100290038)
	e2:SetCondition(c100290038.rccon)
	e2:SetTarget(c100290038.rctg)
	e2:SetOperation(c100290038.rcop)
	c:RegisterEffect(e2)
end
function c100290038.filter(c,tp,pcon)
	return ((c:IsFaceup() and c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_PENDULUM)) or c:IsLocation(LOCATION_GRAVE))
		and c:IsSetCard(0x4) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or c:IsType(TYPE_PENDULUM) and pcon)
end
function c100290038.activate(e,tp,eg,ep,ev,re,r,rp)
	local pcon=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c100290038.filter),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil,tp,pcon)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(100290038,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local sc=g:Select(tp,1,1,nil):GetFirst()
		if sc then
			local b1=sc:IsAbleToHand()
			local b2=sc:IsType(TYPE_PENDULUM) and pcon
			local s=0
			if b1 and not b2 then
				s=Duel.SelectOption(tp,aux.Stringid(100290038,1))
			end
			if not b1 and b2 then
				s=Duel.SelectOption(tp,aux.Stringid(100290038,2))+1
			end
			if b1 and b2 then
				s=Duel.SelectOption(tp,aux.Stringid(100290038,1),aux.Stringid(100290038,2))
			end
			if s==0 then
				Duel.SendtoHand(sc,nil,REASON_EFFECT)
			end
			if s==1 then
				Duel.MoveToField(sc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			end
		end
	end
end
function c100290038.rcfilter(c)
	return c:IsSetCard(0x4) and c:IsFaceup()
end
function c100290038.rccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100290038.rcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100290038.tgfilter(c,e,tp)
	return c:IsCanBeEffectTarget(e) and c:IsControler(1-tp)
end
function c100290038.rctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c100290038.tgfilter(chkc,e,tp) end
	if chk==0 then return eg:IsExists(c100290038.tgfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=eg:FilterSelect(tp,c100290038.tgfilter,1,1,nil,e,tp):GetFirst()
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,tc,1,0,0)
end
function c100290038.rcop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
	end
end