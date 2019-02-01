--Time Thief Redoer
--Script by JoyJ
function c101007085.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,2)
	--attach
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101007085,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c101007085.getmattg)
	e1:SetOperation(c101007085.getmatop)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101007085,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101007085)
	e2:SetCost(c101007085.cost)
	e2:SetTarget(c101007085.tg)
	e2:SetOperation(c101007085.op)
	c:RegisterEffect(e2,false,REGISTER_FLAG_DETACH_XMAT)
end
function c101007085.CanUseMaterialTypeMonster(c)
	return c:IsAbleToRemove()
end
function c101007085.CanUseMaterialTypeSpell(tp)
	return Duel.IsPlayerCanDraw(tp,1)
end
function c101007085.matfilter(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function c101007085.CanUseMaterialTypeTrap(tp)
	return Duel.IsExistingMatchingCard(c101007085.matfilter,tp,0,LOCATION_ONFIELD,1,nil)
end
function c101007085.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	local tg=Group.CreateGroup()
	local ty=0
	
	if not c:CheckRemoveOverlayCard(tp,1,REASON_COST) then return false end
	if c101007085.CanUseMaterialTypeMonster(c) then tg:Merge(g:Filter(Card.IsType,nil,TYPE_MONSTER)) end
	if c101007085.CanUseMaterialTypeSpell(tp) then tg:Merge(g:Filter(Card.IsType,nil,TYPE_SPELL)) end
	if c101007085.CanUseMaterialTypeTrap(tp) then tg:Merge(g:Filter(Card.IsType,nil,TYPE_TRAP)) end
	if chk==0 then return tg:GetCount() > 0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101007085,2))
	local use = Group.CreateGroup()
	while tg:GetCount() > 0 do
		local selected = tg:Select(tp,1,1,nil):GetFirst()
		if selected:IsType(TYPE_MONSTER) then
			ty = ty | TYPE_MONSTER
			tg:Remove(Card.IsType,nil,TYPE_MONSTER)
		end
		if selected:IsType(TYPE_SPELL) then
			ty = ty | TYPE_SPELL
			tg:Remove(Card.IsType,nil,TYPE_SPELL)
		end
		if selected:IsType(TYPE_TRAP) then
			ty = ty | TYPE_TRAP
			tg:Remove(Card.IsType,nil,TYPE_TRAP)
		end
		use:AddCard(selected)
		if tg:GetCount() > 0 and (not Duel.SelectYesNo(tp,aux.Stringid(101007085,2))) then
			tg:Clear()
		end
	end
	e:SetLabel(ty)
	Duel.SendtoGrave(use,REASON_COST)
	Duel.RaiseSingleEvent(c,EVENT_DETACH_MATERIAL,e,0,0,0,0)
end
function c101007085.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ty=e:GetLabel()
	if ty & TYPE_MONSTER ~=0 then Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0) end
	if ty & TYPE_SPELL ~=0 then Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1) end
	if ty & TYPE_TRAP ~=0 then Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_ONFIELD) end
end
function c101007085.effectRemove(c,e,tp)
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c101007085.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c101007085.effectDraw(tp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c101007085.todeckfilter(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function c101007085.effectToDeck(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c101007085.todeckfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount() > 0 then Duel.SendtoDeck(g,nil,0,REASON_EFFECT) end
end
function c101007085.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ty=e:GetLabel()
	local EffectRemove = ty & TYPE_MONSTER ~=0
	local EffectDraw = ty & TYPE_SPELL ~=0
	local EffectToDeck = ty & TYPE_TRAP ~=0
	local selected = -1
	
	if (EffectRemove and EffectDraw and EffectToDeck) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		selected = Duel.SelectOption(tp,aux.Stringid(101007085,4),aux.Stringid(101007085,5),aux.Stringid(101007085,6))
		if selected == 0 then
			EffectRemove = false
			c101007085.effectRemove(c,e,tp)
		end
		if selected == 1 then
			EffectDraw = false
			c101007085.effectDraw(tp)
		end
		if selected == 2 then
			c101007085.effectToDeck(tp)
		end
	end
	
	if (EffectRemove and EffectDraw) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		selected = Duel.SelectOption(tp,aux.Stringid(101007085,4),aux.Stringid(101007085,5))
		if selected == 0 then
			EffectRemove = false
			c101007085.effectRemove(c,e,tp)
		end
		if selected == 1 then
			EffectDraw = false
			c101007085.effectDraw(tp)
		end
	end
	
	if (EffectDraw and EffectToDeck) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		selected = Duel.SelectOption(tp,aux.Stringid(101007085,5),aux.Stringid(101007085,6))
		if selected == 0 then
			EffectRemove = false
			c101007085.effectDraw(tp)
		end
		if selected == 1 then
			EffectDraw = false
			c101007085.effectToDeck(tp)
		end
	end
	
	if (EffectRemove and EffectToDeck) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		selected = Duel.SelectOption(tp,aux.Stringid(101007085,4),aux.Stringid(101007085,6))
		if selected == 0 then
			EffectRemove = false
			c101007085.effectRemove(c,e,tp)
		end
		if selected == 1 then
			EffectDraw = false
			c101007085.effectToDeck(tp)
		end
	end
	if EffectRemove then
		c101007085.effectRemove(c,e,tp)
	end
	if EffectDraw then
		c101007085.effectDraw(tp)
	end
	if EffectToDeck then
		c101007085.effectToDeck(tp)
	end
end
function c101007085.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c101007085.getmattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ((Duel.GetDecktopGroup(1-tp,1)):GetCount() > 0) end
end
function c101007085.getmatop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(1-tp,1)
	if c:IsRelateToEffect(e) and g:GetCount()==1 then
		Duel.Overlay(c,g)
	end
end
