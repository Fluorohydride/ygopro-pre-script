--三刃大师
--Script by 奥克斯
function c100298002.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--synchro summon 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,100298002)
	e1:SetCondition(c100298002.con)
	e1:SetTarget(c100298002.tg)
	e1:SetOperation(c100298002.op)
	c:RegisterEffect(e1)
	--material check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c100298002.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function c100298002.valcheck(e,c)
	local g=c:GetMaterial():Filter(Card.IsLevelAbove,nil,1)
	if #g>0 then
		e:GetLabelObject():SetLabelObject(g)
	else
		e:GetLabelObject():SetLabelObject(nil)
	end
	local b1=g:IsExists(Card.IsLevel,1,nil,1) and g:IsExists(Card.IsLevel,1,nil,5)
	local b2=g:IsExists(Card.IsLevel,1,nil,2) and g:IsExists(Card.IsLevel,1,nil,4)
	local b3=g:IsExists(Card.IsLevel,2,nil,3)
	if b1 then
		e:GetLabelObject():SetLabel(1)
	end
	if b2 then
		e:GetLabelObject():SetLabel(2)
	end
	if b3 then
		e:GetLabelObject():SetLabel(3)
	end
end
function c100298002.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and #g>0 
end
function c100298002.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetLabelObject()
	local ct=e:GetLabel()
	local des=Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
	local draw=Duel.IsPlayerCanDraw(tp,1)
	local tun=not e:GetHandler():IsType(TYPE_TUNER)
	local check1=#lg>=3 and (des or draw or tun)
	local check2=ct==1 and des
	local check3=ct==2 and draw
	local check4=ct==3 and tun
	if chk==0 then return check1 or check2 or check3 or check4 end
	if #lg>=3 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	else
		if ct==1 then
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
			e:SetCategory(CATEGORY_DESTROY)
		elseif ct==2 then
			Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
			e:SetCategory(CATEGORY_DRAW)
		end
	end
end
function c100298002.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lg=e:GetLabelObject()
	local ct=e:GetLabel()
	if #lg==0 then return end
	local des=Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
	local draw=Duel.IsPlayerCanDraw(tp,1)
	local tun=not c:IsType(TYPE_TUNER) and c:IsRelateToChain() and c:IsFaceup()
	if #lg>=3 then
		if des then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
			if #g==0 then return end
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end 
		if draw then Duel.Draw(tp,1,REASON_EFFECT) end
		if tun then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_TYPE)
			e1:SetValue(TYPE_TUNER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
		end   
	else
		if ct==1 and des then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
			if #g==0 then return end
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
		if ct==2 and draw then Duel.Draw(tp,1,REASON_EFFECT) end
		if ct==3 and tun then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_TYPE)
			e1:SetValue(TYPE_TUNER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)  
		end 
	end
end