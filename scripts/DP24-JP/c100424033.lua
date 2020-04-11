--サイコ・ギガサイバー

--Scripted by mallu11
function c100424033.initial_effect(c)
	aux.AddCodeList(c,77585513)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100424033)
	e1:SetCondition(c100424033.spcon)
	c:RegisterEffect(e1)
	--place to szone
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100424033,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100424133)
	e2:SetCondition(c100424033.plcon)
	e2:SetCost(c100424033.plcost)
	e2:SetOperation(c100424033.plop)
	c:RegisterEffect(e2)
end
function c100424033.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return (Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_ONFIELD,0,nil,TYPE_SPELL+TYPE_TRAP)<Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP))
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c100424033.confilter(c)
	return c:IsFaceup() and c:IsCode(77585513)
end
function c100424033.plcon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c100424033.confilter,tp,LOCATION_ONFIELD,0,1,nil) then return false end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsControler(1-tp) and bc:IsFaceup() and bc:IsType(TYPE_EFFECT)
end
function c100424033.plcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() end
	Duel.Release(c,REASON_COST)
end
function c100424033.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_SZONE,tp)>0 end
end
function c100424033.plop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc:IsRelateToBattle() and bc:IsControler(1-tp) then
		if Duel.MoveToField(bc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true) then
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			bc:RegisterEffect(e1)
		end
	end
end
