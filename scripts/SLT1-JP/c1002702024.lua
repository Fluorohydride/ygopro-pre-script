--クロノダイバー・ダブルバレル
--Time Thief Doublebarrel
--LUA by Kohana Sonogami
--
function c1002702024.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,2)
	--Apply
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1002702024,1))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_CHANGE_ATK+CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,1002702024)
	e1:SetCondition(c1002702024.condition)
	e1:SetTarget(c1002702024.target)
	e1:SetOperation(c1002702024.operation)
	c:RegisterEffect(e1)
end
function c1002702024.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c1002702024.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		if not c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then return false end
		local g=c:GetOverlayGroup()
		if g:IsExists(Card.IsType,1,nil,TYPE_MONSTER)
			and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then return true end
		if g:IsExists(Card.IsType,1,nil,TYPE_SPELL)
			and Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) then return true end
		if g:IsExists(Card.IsType,1,nil,TYPE_TRAP)
			and Duel.IsExistingMatchingCard(c1002702024.dfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then return true end
		return false
	end
end
function c1002702024.check(g)
	return g:FilterCount(Card.IsType,nil,TYPE_MONSTER)<=1
		and g:FilterCount(Card.IsType,nil,TYPE_SPELL)<=1
		and g:FilterCount(Card.IsType,nil,TYPE_TRAP)<=1
end
function c1002702024.dfilter(c)
	return c:IsFaceup() and not c:IsDisabled() and c:IsType(TYPE_EFFECT)
end
function c1002702024.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then return end
	local g=c:GetOverlayGroup()
	local tg=Group.CreateGroup()
	if e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then
		tg:Merge(g:Filter(Card.IsType,nil,TYPE_MONSTER))
	end
	if Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) then
		tg:Merge(g:Filter(Card.IsType,nil,TYPE_SPELL))
	end
	if Duel.IsExistingMatchingCard(c1002702024.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
		tg:Merge(g:Filter(Card.IsType,nil,TYPE_TRAP))
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local sg=tg:SelectSubGroup(tp,c1002702024.check,false,1,3)
	if not sg then return end
	Duel.SendtoGrave(sg,REASON_EFFECT)
	Duel.RaiseSingleEvent(c,EVENT_DETACH_MATERIAL,e,0,0,0,0)
	if sg:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(400)
		c:RegisterEffect(e1)
	end
	if sg:IsExists(Card.IsType,1,nil,TYPE_SPELL) then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.HintSelection(g)
		Duel.GetControl(g:GetFirst(),tp,PHASE_END,1)
	end
	if sg:IsExists(Card.IsType,1,nil,TYPE_TRAP) then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,c1002702024.dfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,exc)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
end
