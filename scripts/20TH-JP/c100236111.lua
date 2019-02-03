--奇跡のマジック・ゲート
--
--Script by JoyJ
function c100236111.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c100236111.Condition)
	e1:SetTarget(c100236111.Target)
	e1:SetOperation(c100236111.Operation)
	c:RegisterEffect(e1)
end
function c100236111.TargetFilter(c)
	return c:IsAttackPos() and c:IsCanChangePosition() and c:IsControlerCanBeChanged()
end
function c100236111.Operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,c100236111.TargetFilter,tp,0,LOCATION_MZONE,1,1,nil)
	local c = g:GetFirst()
	if c and Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE)>0 then
		Duel.BreakEffect()
		if Duel.GetControl(c,tp) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		end
	end
end
function c100236111.Target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c100236111.TargetFilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,1-tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,1-tp,LOCATION_MZONE)
end
function c100236111.CostFilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c100236111.Condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100236111.CostFilter,tp,LOCATION_MZONE,0,2,nil)
end
