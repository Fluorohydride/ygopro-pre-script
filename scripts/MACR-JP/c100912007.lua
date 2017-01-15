--SRアクマグネ
--Speedroid Fiendmagnet
--Scripted by Eerie Code
function c100912007.initial_effect(c)
	--cannot be synchro
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c100912007.smcon)
	c:RegisterEffect(e1)
	--material check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c100912007.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--synchro summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100912007,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_CUSTOM+100912007)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c100912007.sptg)
	e4:SetOperation(c100912007.spop)
	c:RegisterEffect(e4)
	if not c100912007.global_flag then
		c100912007.global_flag=true
		--flag reset
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_END)
		ge1:SetOperation(c100912007.resetop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c100912007.smcon(e)
	return e:GetHandler():GetFlagEffect(100912007)==0
end
function c100912007.smcon2(e)
	return e:GetHandler():GetFlagEffect(100912007)>0
end
function c100912007.smtg(e,c)
	return c:GetFlagEffect(100912007)>0
end
function c100912007.filter(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function c100912007.synfilter(c,tm,ntm)
	local g=Group.FromCards(tm,ntm)
	if c:IsFacedown() and c:IsAttribute(ATTRIBUTE_WIND) then 
		if c:IsSynchroSummonable(nil,g) then
			return true
		else return false end
	else return false end
end
function c100912007.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return end
	if bit.band(Duel.GetCurrentPhase(),PHASE_MAIN1+PHASE_MAIN2)==0 then return end
	local c=e:GetHandler()
	c:RegisterFlagEffect(100912007,RESET_EVENT+0x1fe0000,0,1)
	local check=false
	local g=Duel.GetMatchingGroup(c100912007.filter,tp,0,LOCATION_MZONE,nil,e)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
		e1:SetCondition(c100912007.smcon2)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+Duel.GetCurrentPhase())
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(100912007,RESET_EVENT+0x1fe0000,0,1)
		if Duel.IsExistingMatchingCard(c100912007.synfilter,tp,LOCATION_EXTRA,0,1,nil,c,tc) then
			check=true
		else
			tc:ResetFlagEffect(100912007)
		end
		tc=g:GetNext()
	end
	if check and Duel.SelectYesNo(tp,aux.Stringid(100912007,0)) then
		Duel.RaiseSingleEvent(c,EVENT_CUSTOM+100912007,e,r,rp,0,0)
	else
		c:ResetFlagEffect(100912007)
	end
end
function c100912007.spfilter(c,tp,tc)
	return c:GetFlagEffect(100912007)>0 and Duel.IsExistingMatchingCard(c100912007.synfilter,tp,LOCATION_EXTRA,0,1,nil,tc,c)
end
function c100912007.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c100912007.spfilter(chkc,tp,c) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	Duel.SelectTarget(tp,c100912007.spfilter,tp,0,LOCATION_MZONE,1,1,nil,tp,c)
end
function c100912007.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c100912007.synfilter,tp,LOCATION_EXTRA,0,1,1,nil,c,tc)
		local sc=g:GetFirst()
		if sc then
			Duel.SynchroSummon(tp,sc,nil,Group.FromCards(c,tc))
		end
	end
end
function c100912007.resetfilter(c)
	return c:GetFlagEffect(100912007)>0
end
function c100912007.resetop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c100912007.resetfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		tc:ResetFlagEffect(100912007)
		tc=g:GetNext()
	end
end
