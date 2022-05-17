--ブラックフェザー·アサルト·ドラゴン
function c101110042.initial_effect(c)
	c:EnableCounterPermit(0x10)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)

	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101110042,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c101110042.spCon)
	e2:SetOperation(c101110042.spOp)
	c:RegisterEffect(e2)

	--add counter and damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetOperation(c101110042.regOp)
	c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c101110042.addCounterAndDamageCon)
	e4:SetOperation(c101110042.addCounterAndDamageOp)
	c:RegisterEffect(e4)

	--destory
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(101110042,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	--e1:SetProperty(EFFECT_F)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetCondition(c101110042.desCon)
	e5:SetCost(c101110042.desCost)
	e5:SetTarget(c101110042.desTg)
	e5:SetOperation(c101110042.desOp)
	c:RegisterEffect(e5)
	
end

-- todo:hero may has bug, dragon is alse the Tuner
function c101110042.spTunerfilter(c)
	return c:IsType(TYPE_TUNER) and c:IsType(TYPE_SYNCHRO) and c:IsAbleToRemoveAsCost()
end

function c101110042.dragonFilter(c)
	return c:IsCode(9012916) and c:IsAbleToRemoveAsCost()
end

function c101110042.spTunerAndDragonFilter(c,tp,sc)
	return c:IsCode(9012916) and c:IsType(TYPE_TUNER) and c:IsType(TYPE_SYNCHRO) and c:IsAbleToRemoveAsCost()
end

function c101110042.spCon(e,c)
	if c==nil then return true end

	local tp=c:GetControler()
	local dragonCount = Duel.GetMatchingGroupCount(c101110042.dragonFilter, tp, 
					LOCATION_MZONE + LOCATION_GRAVE, 0, nil)

	local dragonTunerCount = Duel.GetMatchingGroupCount(c101110042.spTunerAndDragonFilter, tp, 
					LOCATION_MZONE + LOCATION_GRAVE, 0, nil)
	local notDragonTunerCount = Duel.GetMatchingGroupCount(c101110042.spTunerfilter, tp, 
					LOCATION_MZONE + LOCATION_GRAVE, 0, dragonGroup)

	return dragonCount > 0 and (notDragonTunerCount > 0 or (dragonTunerCount > 0 and dragonCount > 1))
end

function c101110042.spOp(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c101110042.spTunerfilter,tp,LOCATION_MZONE + LOCATION_GRAVE,0,1,1,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c101110042.dragonFilter,tp,LOCATION_MZONE + LOCATION_GRAVE,0,1,1,g1,c)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)

	--Duel.SpecialSummon(c,SUMMON_TYPE_SPECIAL,tp,tp,true,false,POS_FACEUP) 
end

function c101110042.regOp(e,tp,eg,ep,ev,re,r,rp)
	if rp == 1 - tp and re:IsActiveType(TYPE_MONSTER) then
		e:GetHandler():RegisterFlagEffect(101110042,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
	end
	--if rp==tp or not re:IsHasType(EFFECT_TYPE) then return end
end

function c101110042.addCounterAndDamageCon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c:GetFlagEffect(101110042)~=0
end

function c101110042.addCounterAndDamageOp(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,101110042)
	e:GetHandler():AddCounter(0x10,1)
	Duel.Damage(1-tp,700,REASON_EFFECT)
end

function c101110042.desCon(e,tp,eg,ep,ev,re,r,rp) 
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then
		return false 
	end

	-- enenemy, counter enough, has card to destory
	return Duel.GetTurnPlayer()==1-tp and e:GetHandler():GetCounter(0x10) >= 4 
			and Duel.IsExistingMatchingCard(aux.TRUE, tp, LOCATION_ONFIELD,LOCATION_ONFIELD, 1, e:GetHandler())
end

function c101110042.desCost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end

function c101110042.desTg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end

function c101110042.desOp(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD, nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
