--VV－百識公国
--
--Script by Trishula9
function c100418212.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100418212.target)
	e1:SetOperation(c100418212.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,100418212)
	e2:SetCondition(c100418212.stcon)
	e2:SetTarget(c100418212.sttg)
	e2:SetOperation(c100418212.stop)
	c:RegisterEffect(e2)
end
function c100418212.setfilter(c,tp)
	return c:IsSetCard(0x27c) and not c:IsCode(100418212) and c:IsType(TYPE_FIELD) and not c:IsForbidden() and c:CheckUniqueOnField(1-tp)
end
function c100418212.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100418212.setfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c100418212.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c100418212.setfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,1-tp,LOCATION_FZONE,POS_FACEUP,true)
	end
end
function c100418212.stcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(Card.IsLocation,tp,LOCATION_FZONE,LOCATION_FZONE,nil,LOCATION_FZONE)==2
end
function c100418212.stfilter(c,tp)
	local seq=c:GetSequence()
	return seq<=4 and c:IsType(TYPE_EFFECT) and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c100418212.cfilter,tp,LOCATION_MZONE,0,1,nil,seq)
end
function c100418212.cfilter(c,seq)
	return aux.MZoneSequence(c:GetSequence())==4-seq
end
function c100418212.sttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c100418212.stfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c100418212.stfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(100418212,0))
	Duel.SelectTarget(tp,c100418212.stfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
end
function c100418212.seqfilter(c,seq)
	return c:GetSequence()==seq
end
function c100418212.stop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and tc:IsControler(1-tp) and not tc:IsImmuneToEffect(e)) then return end
	local zone=1<<tc:GetSequence()
	local oc=Duel.GetMatchingGroup(c100418212.seqfilter,tp,0,LOCATION_SZONE,nil,tc:GetSequence()):GetFirst()
	if oc then
		Duel.Destroy(oc,REASON_EFFECT)
	end
	if Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true,zone) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end
function c100418212.seqfilter(c,seq)
	return c:GetSequence()==seq
end
