--エコール・ド・ゾーン
--Script by XyLeN
function c100278021.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c) 
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100278021,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,100278021)
	e1:SetCondition(c100278021.tkcon)
	e1:SetTarget(c100278021.tktg)
	e1:SetOperation(c100278021.tkop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(100278021,1)) 
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c100278021.descon)
	e2:SetTarget(c100278021.destg)
	e2:SetOperation(c100278021.desop)
	c:RegisterEffect(e2)
end
function c100278021.tkcon(e,tp,eg,ep,ev,re,r,rp)
	if #eg~=1 then return false end
	local tc=eg:GetFirst()
	return tc~=e:GetHandler() and tc:IsFaceup() and (tc:GetAttack()>0 and tc:GetDefense()>0) and (tc:IsSummonPlayer(1-tp) or tc:IsSummonPlayer(tp))
end
function c100278021.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	--not sure the operation info here
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c100278021.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,100278121,0,0x4011,-2,-2,1,RACE_SPELLCASTER,ATTRIBUTE_DARK) then return end
	if tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE) and Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local atk=tc:GetAttack() 
		local def=tc:GetDefense()
		local p=tc:GetControler()
		local token=Duel.CreateToken(tp,100278121) 
		Duel.SpecialSummonStep(token,0,tp,p,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE)
		e2:SetValue(def)
		token:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e3,true)
	end
	Duel.SpecialSummonComplete()
end
function c100278021.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c100278021.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_MZONE,LOCATION_MZONE,0,nil,100278121)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c100278021.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_MZONE,LOCATION_MZONE,0,nil,100278121)
	Duel.Destroy(g,REASON_EFFECT)
end
