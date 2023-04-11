--火焰喷射
function c100428022.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100428022+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c100428022.target)
	e1:SetOperation(c100428022.activate)
	c:RegisterEffect(e1)
end
function c100428022.tgfilter(c)
	return c:IsRace(RACE_PYRO) and c:IsAbleToGrave()
end
function c100428022.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100428022.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c100428022.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100428022.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) and tc:IsSetCard(0x32) then
		local b1=aux.TRUE
		local b2=Duel.IsPlayerCanSpecialSummonMonster(tp,100428122,0,TYPES_TOKEN_MONSTER,1000,1000,1,RACE_PYRO,ATTRIBUTE_FIRE,POS_FACEUP,1-tp)
		local off=1
		local ops,opval={},{}
		if b1 then
			ops[off]=aux.Stringid(100428022,0)
			opval[off]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(100428022,1)
			opval[off]=2
			off=off+1
		end
		ops[off]=aux.Stringid(100428022,2)
		opval[off]=0
		local op=Duel.SelectOption(tp,table.unpack(ops))+1
		local sel=opval[op]
		if sel==1 then
			local val=tc:GetLevel()*100
			Duel.Damage(1-tp,val,REASON_EFFECT)
		elseif sel==2 then
			local token=Duel.CreateToken(tp,100428122)
			if Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_LEAVE_FIELD)
				e1:SetOperation(c100428022.damop)
				token:RegisterEffect(e1,true)
			end
			Duel.SpecialSummonComplete()
		end
	end
end
function c100428022.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_DESTROY) then
		Duel.Damage(c:GetPreviousControler(),500,REASON_EFFECT)
	end
	e:Reset()
end