--Three Tactical Talents
--Scripted by: XGlitchy30
function c101101062.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101101062+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c101101062.condition)
	e1:SetTarget(c101101062.target)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(101101062,ACTIVITY_CHAIN,c101101062.chainfilter)
end
function c101101062.chainfilter(re,tp,cid)
	local ph=Duel.GetCurrentPhase()
	return not (re:IsActiveType(TYPE_MONSTER) and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2))
end
function c101101062.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(101101062,1-tp,ACTIVITY_CHAIN)~=0
end
function c101101062.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsPlayerCanDraw(tp,2)
	local b2=Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil)
	local b3=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
	if chk==0 then return b1 or b2 or b3 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(101101062,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(101101062,1)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(101101062,2)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		e:SetCategory(CATEGORY_DRAW)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e:SetOperation(c101101062.draw)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(2)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	elseif opval[op]==2 then
		e:SetCategory(CATEGORY_CONTROL)
		e:SetProperty(0)
		e:SetOperation(c101101062.control)
		local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE):Filter(Card.IsControlerCanBeChanged,nil)
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	elseif opval[op]==3 then
		e:SetCategory(CATEGORY_TODECK)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e:SetOperation(c101101062.todeck)
		Duel.SetTargetPlayer(tp)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,1-tp,LOCATION_HAND)
	else
		return
	end
end
function c101101062.draw(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c101101062.control(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.GetControl(g:GetFirst(),tp,PHASE_END,1)
	end
end
function c101101062.todeck(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
	if #g>0 then
		Duel.ConfirmCards(p,g)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local sg=g:FilterSelect(p,Card.IsAbleToDeck,1,1,nil)
		if #sg<=0 then return end
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		Duel.ShuffleHand(1-p)
	end
end
