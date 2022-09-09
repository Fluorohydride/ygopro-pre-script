--メンタル·チュ一ナ一
--Script by 奥克斯
local s,id,o=GetID()
function s.initial_effect(c)
	--level up/down
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,5))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.lvtg)
	c:RegisterEffect(e1)
end

function s.costfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) 
		and c:IsAbleToRemoveAsCost()
end
function s.costfilter1(c,attr)
	return c:GetOriginalAttribute()~=attr
		and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) 
		and c:IsAbleToRemoveAsCost()
end
function s.tgfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) 
		and c:IsFaceup() and c:IsAbleToGrave()
end
function s.tgfilter1(c,attr)
	return c:GetOriginalAttribute()~=attr
		and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) 
		and c:IsFaceup() and c:IsAbleToGrave()
end
function s.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and s.tgfilter(chkc) end
	local b1=Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) 
	local b2=Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_REMOVED,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then 
		op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	elseif b1 then 
		op=Duel.SelectOption(tp,aux.Stringid(id,0))
	else 
		op=Duel.SelectOption(tp,aux.Stringid(id,1))+1 
	end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
		local attr=g:GetFirst():GetOriginalAttribute()
		if  Duel.IsExistingMatchingCard(s.costfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,attr) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g1=Duel.SelectMatchingCard(tp,s.costfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,attr)
			g:Merge(g1)
		end
		Duel.Remove(g,POS_FACEUP,REASON_COST)
		e:SetLabel(#g)
		e:SetProperty(0)
		e:SetOperation(s.lvop1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
		local attr=g:GetFirst():GetOriginalAttribute()
		if  Duel.IsExistingTarget(s.tgfilter1,tp,LOCATION_REMOVED,0,1,nil,attr) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g1=Duel.SelectTarget(tp,s.tgfilter1,tp,LOCATION_REMOVED,0,1,1,nil,attr)
			g:Merge(g1)
		end
		e:SetCategory(CATEGORY_TOGRAVE)
		e:SetProperty(0)
		e:SetOperation(s.lvop2)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	end
end
function s.lvop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local lv=e:GetLabel()
	local op=0
	if c:IsLevelBelow(lv) then 
		 op=Duel.SelectOption(tp,aux.Stringid(id,3))
	else 
		 op=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4)) 
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	if op==0 then
		e1:SetValue(lv)
	else
		e1:SetValue(-lv)
	end
	c:RegisterEffect(e1)
end

function s.lvop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)>0
		and c:IsFaceup() and c:IsRelateToEffect(e) then
		local lv=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
		local op=0
		if c:IsLevelBelow(lv) then 
			op=Duel.SelectOption(tp,aux.Stringid(id,3))
		else 
			op=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4)) 
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		if op==0 then
			e1:SetValue(lv)
		else
			e1:SetValue(-lv)
		end
		c:RegisterEffect(e1)
	end
end