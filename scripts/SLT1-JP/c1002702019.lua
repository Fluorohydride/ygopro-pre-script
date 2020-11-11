--フェアリーテール
--LUA by Kohana Sonogami
--Fairy Tail
--
function c1002702019.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Normal Summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,1002702019)
	e2:SetCost(c1002702019.nscost)
	e2:SetTarget(c1002702019.nstg)
	e2:SetOperation(c1002702019.nsop)
	c:RegisterEffect(e2)
	--Avoid Damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,0)
	e3:SetValue(c1002702019.damval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e4:SetCondition(c1002702019.damcon)
	c:RegisterEffect(e4)
end
function c1002702019.nsfilter(c,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttack(1850) and c:IsSummonable(true,nil)
		and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,c:GetCode())
end
function c1002702019.nscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1002702019.nsfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c1002702019.nsfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.SetTargetCard(g)
end
function c1002702019.nstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1002702019.nsfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c1002702019.nsop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Summon(tp,tc,true,nil)
	end
end
function c1002702019.damfilter(c)
	return c:IsAttack(1850) and c:IsRace(RACE_SPELLCASTER) and c:IsFaceup()
end
function c1002702019.damcon(tp)
	return Duel.IsExistingMatchingCard(c1002702019.damfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c1002702019.damval(e,re,val,r,rp,rc)
	local tp=e:GetHandlerPlayer()
	local c=e:GetHandler()
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 and c:GetFlagEffect(1002702019)==0 and c1002702019.damcon(tp) then
		c:RegisterFlagEffect(1002702019,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		return 0
	end
	return val
end
