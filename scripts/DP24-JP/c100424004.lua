--古の呪文

--Scripted by mallu11
function c100424004.initial_effect(c)
	aux.AddCodeList(c,10000010)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100424004,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100424004+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c100424004.condition)
	e1:SetTarget(c100424004.target)
	e1:SetOperation(c100424004.activate)
	c:RegisterEffect(e1)
	--gain atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100424004,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c100424004.gaintg)
	e2:SetOperation(c100424004.gainop)
	c:RegisterEffect(e2)
end
function c100424004.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c100424004.filter(c)
	return c:IsCode(10000010) and c:IsAbleToHand()
end
function c100424004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100424004.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.IsPlayerCanSummon(tp) and Duel.IsPlayerCanAdditionalSummon(tp) and Duel.GetFlagEffect(tp,100424004)==0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c100424004.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c100424004.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if g:GetFirst():IsLocation(LOCATION_HAND) then
			if Duel.GetFlagEffect(tp,100424004)~=0 then return end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetTargetRange(LOCATION_HAND,0)
			e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
			e1:SetValue(0x1)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_EXTRA_SET_COUNT)
			Duel.RegisterEffect(e2,tp)
			Duel.RegisterFlagEffect(tp,100424004,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function c100424004.gaintg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,100424104)==0 end
end
function c100424004.gainop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,100424104)~=0 then return end
	local c=e:GetHandler()
	--tribute check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e1:SetValue(c100424004.valcheck)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--give atk effect only when summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SUMMON_COST)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetTarget(c100424004.tgchk)
	e2:SetOperation(c100424004.facechk)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetLabelObject(e1)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterFlagEffect(tp,100424104,RESET_PHASE+PHASE_END,0,1)
end
function c100424004.valcheck(e,c)
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local g=c:GetMaterial()
		local tc=g:GetFirst()
		local atk=0
		local def=0
		while tc do
			atk=atk+math.max(tc:GetTextAttack(),0)
			def=def+math.max(tc:GetTextDefense(),0)
			tc=g:GetNext()
		end
		--atk continuous effect
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		c:RegisterEffect(e1)
		--def continuous effect
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(def)
		c:RegisterEffect(e2)
	end
end
function c100424004.tgchk(e,c)
	return c:IsCode(10000010)
end
function c100424004.facechk(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(1)
end
