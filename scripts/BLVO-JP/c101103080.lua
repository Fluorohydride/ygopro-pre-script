--壱時砲固定式
--Stationary One-o'-Clock Linear Accelerator
--Scripted by Gecko-chan
function c101103080.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,101103080)
	e1:SetTarget(c101103080.target)
	e1:SetOperation(c101103080.activate)
	c:RegisterEffect(e1)
end
function c101103080.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsLevelAbove(1)
end
function c101103080.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c101103080.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c101103080.filter,tp,0,LOCATION_MZONE,1,nil) end
	local t={}
	local i=1
	for i=1,6 do t[i]=i end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NUMBER)
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
end
function c101103080.activate(e,tp,eg,ep,ev,re,r,rp)
	--Set up the equation
	local dnum=e:GetLabel()
	local fnum=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	local gnum=Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)
	local dg=Duel.GetMatchingGroup(c101103080.filter,tp,0,LOCATION_ONFIELD,nil)
	local mon=dg:Select(tp,1,1,nil)
	local lnum=mon:GetFirst():GetLevel()
	--The equation
	if ((lnum*dnum)+fnum)==gnum then
		--Select number of cards to send from Deck to GY
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		local t={}
		local i=1
		if dcount<=dnum then
			for i=1,dcount do t[i]=i end
		else
			for i=1,dnum do t[i]=i end
		end
		local snum=Duel.AnnounceNumber(tp,table.unpack(t))
		Duel.DiscardDeck(tp,snum,REASON_EFFECT)
		--Shuffle opponent's cards into Deck
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local rg=dg:Select(tp,1,snum,nil)
		Duel.HintSelection(rg)
		Duel.SendtoDeck(rg,nil,snum,REASON_EFFECT)
	else
		--Inflict damage
		Duel.Damage(tp,dnum*500,REASON_EFFECT)
	end
end
