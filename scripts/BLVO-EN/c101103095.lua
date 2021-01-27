--War Rock Orpis
--Scripted by Kohana Sonogami
function c101103095.initial_effect(c)
	--normal summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101103095,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c101103095.ntcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--tograve & atkchange
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101103095,1))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_BATTLED)
	e1:SetCountLimit(1,101103095)
	e1:SetTarget(c101103095.tgtg)
	e1:SetOperation(c101103095.tgop)
	c:RegisterEffect(e1)
end
function c101103095.cfilter(c)
	return c:IsFacedown() or not c:IsRace(RACE_WARRIOR)
end
function c101103095.ntcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return minc==0 and c:IsLevelAbove(4) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 or not Duel.IsExistingMatchingCard(c101103095.cfilter,tp,LOCATION_MZONE,0,1,nil))
end
function c101103095.tgfilter(c)
	return c:IsAttributr(ATTRIBUTE_EARTH) and c:IsRace(RACE_WARRIOR) and c:IsAbleToGrave() and not c:IsCode(101103095)
end
function c101103095.check(c,tp)
	return c and c:IsControler(tp) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_WARRIOR)
end
function c101103095.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetAttackTarget()~=nil
		and (c101103095.check(Duel.GetAttacker(),tp) or c101103095.check(Duel.GetAttackTarget(),tp))
		and Duel.IsExistingMatchingCard(c101103095.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	if c101103095.check(Duel.GetAttacker(),tp) then
		Duel.SetTargetCard(Duel.GetAttackTarget())
	else
		Duel.SetTargetCard(Duel.GetAttacker())
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c101103095.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x263)
end
function c101103095.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101103095.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT) then
		Duel.BreakEffect()
		local sg=Duel.GetMatchingGroup(c101103095.atkfilter,tp,LOCATION_MZONE,0,nil)
		local tc=sg:GetFirst() 
		for tc in aux.Next(sg) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,Duel.GetTurnPlayer()==tp and 2 or 1)
			e1:SetValue(200)
			tc:RegisterEffect(e1)
		end
	end
end
