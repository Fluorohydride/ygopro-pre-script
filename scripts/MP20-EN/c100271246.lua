--Successor Soul
--Scripted by TOP
function c100271246.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100271246,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,100271246+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c100271246.cost)
	e1:SetTarget(c100271246.target)
	e1:SetOperation(c100271246.activate)
	c:RegisterEffect(e1)
	if not c100271246.global_check then
		c100271246.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c100271246.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c100271246.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p=tc:GetControler()
	if tc:GetFlagEffect(100271246)==0 then
		tc:RegisterFlagEffect(100271246,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		if Duel.GetFlagEffect(p,100271246)==0 then
			Duel.RegisterFlagEffect(p,100271246,RESET_PHASE+PHASE_END,0,1)
		else
			Duel.RegisterFlagEffect(p,100271246+100,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function c100271246.costfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_EFFECT) and (c:IsFaceup() or c:IsControler(tp))
end
function c100271246.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,100271246+100)==0
		and Duel.CheckReleaseGroup(tp,c100271246.costfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c100271246.costfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
	--cannot attack
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c100271246.atkcon)
	e1:SetTarget(c100271246.atktg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c100271246.atkcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),100271246)~=0
end
function c100271246.atktg(e,c)
	return c:GetFlagEffect(100271246)==0
end
function c100271246.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsAbleToGrave()
end
function c100271246.spfilter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsLevelAbove(7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100271246.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c100271246.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100271246.filter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c100271246.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c100271246.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND+LOCATION_DECK)
end
function c100271246.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c100271246.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.BreakEffect()
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
