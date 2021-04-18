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
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1,100278021)
	e1:SetCondition(c100278021.tkcon)
	e1:SetTarget(c100278021.tktg)
	e1:SetOperation(c100278021.tkop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100278021,1))
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_LEAVE_FIELD_P)
	e4:SetOperation(c100278021.desop)
	c:RegisterEffect(e4)
end
function c100278021.tkcon(e,tp,eg,ep,ev,re,r,rp)
	if #eg~=1 then return false end
	local tc=eg:GetFirst()
	return tc:IsSummonPlayer(Duel.GetTurnPlayer())
end
function c100278021.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=eg:GetFirst()
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c100278021.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	local p=tc:GetControler()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0
		and Duel.GetLocationCount(p,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(p,100278121,0,0x4011,-2,-2,1,RACE_SPELLCASTER,ATTRIBUTE_DARK) then
		local atk=tc:GetAttack()
		local def=tc:GetDefense()
		local token=Duel.CreateToken(tp,100278121)
		Duel.SpecialSummonStep(token,0,p,p,false,false,POS_FACEUP)
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
		e3:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e3,true)
	end
	Duel.SpecialSummonComplete()
end
function c100278021.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsFacedown() then return end
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_MZONE,LOCATION_MZONE,0,nil,100278121)
	Duel.Destroy(g,REASON_EFFECT)
end
