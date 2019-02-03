--ウィッチクラフトマスター・ヴェール
--
--Script by JoyJ
function c100412019.initial_effect(c)
	--atkdef
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100412019,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c100412019.BattleCondition)
	e1:SetTarget(c100412019.BattleTarget)
	e1:SetOperation(c100412019.BattleOperation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101412017,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMING_SUMMON+TIMING_SPSUMMON)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,c100412019)
	e2:SetCost(c100412019.DisableCost)
	e2:SetTarget(c100412019.DisableTarget)
	e2:SetOperation(c100412019.DisableOperation)
	c:RegisterEffect(e2)
end
function c100412019.DisableAddEffect(c)
	Duel.NegateRelatedChain(c,RESET_TURN_SET)
	local e1=Effect.CreateEffect(c100412019.EffectHandler)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c100412019.EffectHandler)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetValue(RESET_TURN_SET)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
	if c:IsType(TYPE_TRAPMONSTER) then
		local e3=Effect.CreateEffect(c100412019.EffectHandler)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e3)
	end
end
c100412019.EffectHandler = nil
function c100412019.DisableOperation(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.GetMatchingGroup(c100412019.DisableTargetFilter,tp,0,LOCATION_ONFIELD,nil)
	c100412019.EffectHandler = e:GetHandler()
	g:ForEach(c100412019.DisableAddEffect)
end
function c100412019.DisableTargetFilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_EFFECT) and c:IsFaceup()
end
function c100412019.DisableTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local count = Duel.GetMatchingGroupCount(c100412019.DisableTargetFilter,tp,0,LOCATION_ONFIELD,nil)
	if chk == 0 then return count > 0 end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,count,1-tp,LOCATION_ONFIELD)
end
function c100412019.DisableCostFilter(c)
	return c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function c100412019.DisableCost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100412019.DisableCostFilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c100412019.DisableCostFilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c100412019.BattleOperation(e,tp,eg,ep,ev,re,r,rp)
	local playerCard = e:GetLabelObject()
	local g = Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,nil,TYPE_SPELL)
	if playerCard:IsRelateToBattle() and playerCard:IsFaceup() and playerCard:IsRelateToEffect(e) then
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(100412019,2))
		local selectedCount = 1
		local lastSelected = g:Select(tp,1,1,nil)
		while true do
			g:Remove(Card.IsCode,nil,lastSelected:GetFirst():GetCode())
			if not (g:GetCount() > 0 and Duel.SelectYesNo(tp,aux.Stringid(100412019,3))) then
				break
			end
			lastSelected = g:Select(tp,1,1,nil)
			selectedCount = selectedCount + 1
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(selectedCount * 1000)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
		playerCard:RegisterEffect(e1)
		local e2=Effect.Clone(e1)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		playerCard:RegisterEffect(e2)
	end
end
function c100412019.BattleTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local playerCard=Duel.GetAttacker()
	if (playerCard:GetControler() ~= tp) then
		playerCard = playerCard:GetBattleTarget()
	end
	e:SetLabelObject(playerCard)
	if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_HAND,0,1,nil,TYPE_SPELL) end
	playerCard:CreateEffectRelation(e)
end
function c100412019.BattleCondition(e,tp,eg,ep,ev,re,r,rp)
	local playerCard=Duel.GetAttacker()
	local enemyCard = playerCard:GetBattleTarget()
	if ( (not (playerCard and enemyCard)) or playerCard:GetControler() == enemyCard:GetControler()) then return false end
	if (playerCard:GetControler() ~= tp) then
		playerCard = playerCard:GetBattleTarget()
	end
	return playerCard:IsRace(RACE_SPELLCASTER)
end
