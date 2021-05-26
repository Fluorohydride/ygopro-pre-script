--War Rock Mammud
--Script By JSY1728
function c101104087.initial_effect(c)
	--Tribute Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101104087,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c101104087.tscon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--ATK UP
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101104087,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_BATTLED)
	e2:SetCountLimit(1,101104087)
	e2:SetTarget(c101104087.dstg)
	e2:SetOperation(c101104087.dsop)
	c:RegisterEffect(e2)
end
function c101104087.cfilter(c)
	return c:IsFacedown() or not c:IsRace(RACE_WARRIOR)
end
function c101104087.tscon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 or not Duel.IsExistingMatchingCard(c101104087.cfilter,tp,LOCATION_MZONE,0,1,nil))
end
function c101104087.check(c,tp)
	return c and c:IsControler(tp) and c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function c101104087.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (c101104087.check(Duel.GetAttacker(),tp) or c101104087.check(Duel.GetAttackTarget(),tp))
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101104087.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x15f)
end
function c101104087.dsop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 and Duel.Destroy(sg,REASON_EFFECT) then
		Duel.BreakEffect()
		local ag=Duel.GetMatchingGroup(c101104087.atkfilter,tp,LOCATION_MZONE,0,nil)
		local tc=ag:GetFirst()
		for tc in aux.Next(ag) do
			local c=e:GetHandler()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			e1:SetValue(200)
			tc:RegisterEffect(e1)
		end
	end
end